class RidesController < ApplicationController

  before_action :authenticate_rider!
  before_action :is_active_check, only: :create
  rescue_from Pundit::NotAuthorizedError, with: :rider_not_authorized

  layout 'rider_layout'

    def new
      @ride = Ride.new
    end

    def show
      @ride = Ride.find(params[:id])
      unless RidePolicy.new(current_rider, @ride).show?
          raise Pundit::NotAuthorizedError
      end
      @start_location = Location.find(@ride.start_location_id)
      @end_location = Location.find(@ride.end_location_id)
    end

    def index
      if params[:status] == "pending"
        @rides = current_rider.rides.pending
      elsif params[:status] == "approved"
        @rides = current_rider.rides.approved
      elsif params[:status] == 'canceled'
        @rides = current_rider.rides.canceled
      elsif params[:status] == 'scheduled'
        @rides = current_rider.rides.scheduled
      elsif params[:status] == 'picking-up'
        @rides = current_rider.rides.picking_up
      elsif params[:status] == 'dropping-off'
        @rides = current_rider.rides.dropping_off
      elsif params[:status] == 'completed'
        @rides = current_rider.rides.completed
      else
        @rides = current_rider.rides
      end
      @rides = Kaminari.paginate_array(@rides).page(params[:page]).per(10)
    end

    def create
      token = nil
      if current_rider.organization.use_tokens == true
        token = current_rider.next_valid_token
      end
      if current_rider.organization.use_tokens == false or token != nil
        @start_location = Location.new(
          street: ride_params[:start_street],
          city: ride_params[:start_city],
          state: ride_params[:start_state],
          zip: ride_params[:start_zip])
        save_location_error_handler(@start_location)
        
        @end_location = Location.new(
          street: ride_params[:end_street],
          city: ride_params[:end_city],
          state: ride_params[:end_state],
          zip: ride_params[:end_zip])
        save_location_error_handler(@end_location)
        
        @ride = Ride.new(
          rider_id: current_rider.id,
          organization_id: current_rider.organization.id,
          pick_up_time: ride_params[:pick_up_time],
          start_location_id: @start_location.id,
          end_location_id: @end_location.id,
          reason: ride_params[:reason])
        if current_rider.organization.use_tokens?
          @ride.status = "approved"
        else
          @ride.status = "pending"
        end
        if @ride.save
        rider_choose_save_location
        only_15_location_saves
          if token != nil
            token.ride_id = @ride.id
            token.save
          end
          flash[:notice] = "Ride created."
          redirect_to @ride
        else
          flash[:error] = @ride.errors.full_messages.join(" ")
          render 'new'
        end
      else
        flash[:notice] = "You do not have enough valid tokens to request this ride"
        redirect_to rides_path
      end
    end

    def edit
      @ride = Ride.find(params[:id])
      unless RidePolicy.new(current_rider, @ride).edit?
        raise Pundit::NotAuthorizedError
      end
    end

    def update
      @ride = Ride.find(params[:id])
      unless RidePolicy.new(current_rider, @ride).update?
        raise Pundit::NotAuthorizedError
      end
      @start_location = @ride.start_location
      @end_location = @ride.end_location
      start_location = Location.new(
        street: ride_params[:start_street],
        city: ride_params[:start_city],
        state: ride_params[:start_state],
        zip: ride_params[:start_zip])
      update_location_error_handler(start_location)
      end_location = Location.new(
        street: ride_params[:end_street],
        city: ride_params[:end_city],
        state: ride_params[:end_state],
        zip: ride_params[:end_zip])
      update_location_error_handler(end_location)
      rider_choose_save_location
      only_15_location_saves(location)
      if @ride.update(
        pick_up_time: ride_params[:pick_up_time],
        reason: ride_params[:reason],
        start_location: start_location,
      end_location: end_location)
        flash.notice = "The ride information has been updated"
        redirect_to ride_path(@ride)
      else
        render 'edit'
      end
    end

    def cancel
      @ride = Ride.find(params[:id])
      @ride.rider_id == current_rider.id
      if ['pending', 'approved', 'scheduled'].include? @ride.status
        @ride.update_attributes(status: 'canceled')
        @ride.token.update_attribute(:ride_id, nil)
        flash.notice = 'Ride canceled'
        redirect_to request.referrer || rides_path
      else
        flash.notice = "Sorry the ride status is uncancellable."
        redirect_to request.referrer || rides_path
      end
    end

    private
    def ride_params
      params.require(:ride).permit(:rider_id, :driver_id, :pick_up_time,
       :save_start_location, :start_street, :start_city, :start_state, :start_zip,
       :save_end_location, :end_street, :end_city, :end_state, :end_zip, :reason, :status)
    end
    
    def save_location_error_handler(location)
      byebug
        if !location.save
          byebug
          flash[:error] = location.errors.full_messages.join(" ")
          render 'new'
        end
    end
    
    def update_location_error_handler(location)
      if !location.save
        flash.now[:alert] = location.errors.full_messages.join("\n")
        @ride = Ride.find(params[:id])
        render 'edit'
        return
      end
    end
    
    def rider_choose_save_location
      if ride_params[:save_start_location] == "saved"
        LocationRelationship.create(location_id: @start_location.id, rider_id: current_rider.id)
      end
      if ride_params[:save_end_location] == "saved"
        LocationRelationship.create(location_id: @end_location.id, rider_id: current_rider.id)
      end
    end
    
    def only_15_location_saves
      byebug
      if ride_params[:save_start_location] == "saved" or ride_params[:save_end_location] == "saved"
        # byebug
         rider_location = Location.joins(:location_relationships).distinct.order(updated_at: :desc)
          if (rider_location.count > 15)
            for i in (15..rider_location.count-1) do
              rider_location[i].destroy
              byebug
            end
          end
      end 
    end

    def rider_not_authorized
      flash.notice = "You are not authorized to view this information"
      redirect_to rides_path
    end

    def is_active_check
      if !current_rider.is_active?
        redirect_to rides_path
        flash.alert = "Sorry, you're deactivated."
      end
    end
end
