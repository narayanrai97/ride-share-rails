# frozen_string_literal: true

class AdminRideController < ApplicationController
  before_action :authenticate_user!
#  before_action :rider_is_active, only: :create
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  layout 'administration'

  def new
    @ride = Ride.new
  end

  def show
    @ride = Ride.find(params[:id])
    authorize @ride
  end

  def index
    if params[:status] == "pending"
      @rides = current_user.organization.rides.pending
    elsif params[:status] == 'approved'
      @rides = current_user.organization.rides.approved
    elsif params[:status] == 'canceled'
      @rides = current_user.organization.rides.canceled
    elsif params[:status] == 'scheduled'
      @rides = current_user.organization.rides.scheduled
    elsif params[:status] == 'picking-up'
      @rides = current_user.organization.rides.picking_up
    elsif params[:status] == 'dropping-off'
      @rides = current_user.organization.rides.dropping_off
    elsif params[:status] == 'completed'
      @rides = current_user.organization.rides.completed
    else
      @rides = current_user.organization.rides
    end
    @rides = Kaminari.paginate_array(@rides).page(params[:page]).per(10)
  end

  def edit
    @ride = Ride.find(params[:id])
    authorize @ride
  end

  def create
    begin
      rider = Rider.find(ride_params[:rider_id])
    rescue ActiveRecord::RecordNotFound => e
      flash.now[:alert] = "The rider can't be blank."
       @ride = Ride.new
       render 'new'
       return
    end
    authorize rider
    rider_is_active
    organization = Organization.find(current_user.organization_id)
    if organization.use_tokens == true
      token = rider.next_valid_token
      token = rider.valid_tokens.create if token.nil?
    end
    @start_location = Location.new(street: ride_params[:start_street],
                                  city: ride_params[:start_city],
                                  state: ride_params[:start_state],
                                  zip: ride_params[:start_zip])
    save_location_error_handler(@start_location)
    @end_location = Location.new(street: ride_params[:end_street],
                                city: ride_params[:end_city],
                                state: ride_params[:end_state],
                                zip: ride_params[:end_zip])
    save_location_error_handler(@end_location)
    @ride = Ride.new(organization_id: current_user.organization_id,
                            rider_id:  rider.id,
                            pick_up_time: ride_params[:pick_up_time],
                            start_location_id: @start_location.id,
                            end_location_id: @end_location.id,
                            reason: ride_params[:reason])
    organization.use_tokens ? @ride.status = "approved" : @ride.status = "pending"
    if @ride.save
      rider_choose_save_location
      only_15_location_saves
      if organization.use_tokens == true
        token.ride_id = @ride.id
        token.save
      end
      flash[:notice] = "Ride created for #{rider.full_name}"
      redirect_to admin_ride_path(@ride)
    else
      flash.now[:alert] = @ride.errors.full_messages.join("\n")
      @ride = Ride.new
      render 'new'
    end
  end

  def update
    @ride = Ride.find(params[:id])
    authorize @ride
    @start_location = @ride.start_location
    @end_location = @ride.end_location
    start_location = Location.new( street: ride_params[:start_street],
                       city: ride_params[:start_city],
                       state: ride_params[:start_state],
                       zip: ride_params[:start_zip] )
    update_location_error_handler(start_location)
    end_location = Location.new( street: ride_params[:end_street],
                     city: ride_params[:end_city],
                     state: ride_params[:end_state],
                     zip: ride_params[:end_zip] )
    update_location_error_handler(end_location)
    rider_choose_save_location
    only_15_location_saves
    if @ride.update(
      organization_id: current_user.organization_id,
      rider_id: ride_params[:rider_id],
      pick_up_time: ride_params[:pick_up_time],
      reason: ride_params[:reason]
    )
      flash.notice = 'The ride information has been updated.'
      redirect_to admin_ride_path(@ride)
    else
      render 'edit'
    end
  end

  def approve
    @ride = Ride.find(params[:id])
    authorize @ride
    @ride.update_attributes(status: 'approved')
    flash.notice = 'Ride approved.'
    redirect_to request.referrer || admin_ride_index_path
  end

  def cancel
    @ride = Ride.find(params[:id])
    authorize @ride
    if ['pending', 'approved', 'scheduled'].include? @ride.status
      @ride.update_attributes(status: 'canceled')
      @ride.token.update_attribute(:ride_id, nil)
      flash.notice = 'Ride canceled.'
      redirect_to request.referrer || admin_ride_index_path
    end
  end


  private

  def ride_params
    params.require(:ride).permit(:rider_id, :driver_id, :pick_up_time,:save_start_location,
                                 :save_end_location, :organization_rider_start_location,  :start_street, :start_city,
                                 :start_state, :start_zip, :organization_rider_end_location,
                                 :end_street, :end_city, :end_state, :end_zip, :reason, :status)
  end
  
  def save_location_error_handler(location)
    if !location.save
      flash.now[:alert] = location.errors.full_messages.join("\n")
      @ride = Ride.new
      render 'new'
      return
    end
  end
  
  def update_location_error_handler(location)
    if !location.save
       flash.now[:alert] = start_location.errors.full_messages.join("\n")
       @ride = Ride.find(params[:id])
       render 'edit'
       return
    end
  end
    
  def rider_choose_save_location
    if ride_params[:save_start_location]
        LocationRelationship.create(location_id: @ride.start_location.id, organization_id: current_user.organization.id)
    end
    if ride_params[:save_end_location]
        LocationRelationship.create(location_id: @ride.end_location.id, organization_id: current_user.organization.id)
    end
  end
  
  def only_15_location_saves
    if ride_params[:save_start_location] == true or ride_params[:save_end_location] == true
        org_lrs = organization.location_relationships.order(update_at: :desc)
        if (org_lrs.count > 15)
          for i in (15..org_lrs.count-1) do
            org_lrs[i].destroy
          end
        end
    end
  end

  def user_not_authorized
    flash.notice = 'You are not authorized to view this information'
    redirect_to admin_ride_index_url
  end

  def rider_is_active
    rider = Rider.find(params[:ride][:rider_id])
    if  !rider.is_active?
      flash.alert = "The rider is deactivated."
      redirect_to admin_ride_index_path
    end
  end
end
