# frozen_string_literal: true

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
    @rides = if params[:status] == 'pending'
               current_rider.rides.pending
             elsif params[:status] == 'approved'
               current_rider.rides.approved
             elsif params[:status] == 'canceled'
               current_rider.rides.canceled
             elsif params[:status] == 'scheduled'
               current_rider.rides.scheduled
             elsif params[:status] == 'picking-up'
               current_rider.rides.picking_up
             elsif params[:status] == 'dropping-off'
               current_rider.rides.dropping_off
             elsif params[:status] == 'completed'
               current_rider.rides.completed
             else
               current_rider.rides
             end
    @rides = Kaminari.paginate_array(@rides).page(params[:page]).per(10)
  end

  def create
    token = nil
    if current_rider.organization.use_tokens == true
      token = current_rider.next_valid_token
    end
    if (current_rider.organization.use_tokens == false) || !token.nil?
      @start_location = Location.new(
        street: ride_params[:start_street],
        city: ride_params[:start_city],
        state: ride_params[:start_state],
        zip: ride_params[:start_zip]
       )
      @end_location = Location.new(
        street: ride_params[:end_street],
        city: ride_params[:end_city],
        state: ride_params[:end_state],
        zip: ride_params[:end_zip]
       )
      @ride = Ride.new(
        rider_id: current_rider.id,
        organization_id: current_rider.organization.id,
        pick_up_time: ride_params[:pick_up_time],
        reason: ride_params[:reason]
      )
      location = save_location_error_handler(@start_location)
      if location.nil?
        flash.now[:alert] = @start_location.errors.full_messages.join("\n")
        # @ride = Ride.new
        render "new"
        return
      else
        @start_location = location
      end
      location = save_location_error_handler(@end_location)
      if location.nil?
        flash.now[:alert] = @end_location.errors.full_messages.join("\n")
        # @ride = Ride.new
        render "new"
        return
      else
        @end_location = location
      end
       @ride.start_location_id = @start_location.id
       @ride.end_location_id = @end_location.id
      @ride.status = if current_rider.organization.use_tokens?
                       'approved'
                     else
                       'pending'
                     end
      if @ride.save
        rider_choose_save_location
        only_15_location_saves
        unless token.nil?
          token.ride_id = @ride.id
          token.save
        end
        flash[:notice] = 'Ride created.'
        redirect_to @ride
      else
        flash[:error] = @ride.errors.full_messages.join(' ')
        render 'new'
      end
    else
      flash[:notice] = 'You do not have enough valid tokens to request this ride'
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
      zip: ride_params[:start_zip]
    )
    l_up = update_location_error_handler(start_location)
    return if l_up.nil?

    end_location = Location.new(
      street: ride_params[:end_street],
      city: ride_params[:end_city],
      state: ride_params[:end_state],
      zip: ride_params[:end_zip]
    )
    l_up1 = update_location_error_handler(end_location)
    return if l_up1.nil?

    rider_choose_save_location
    only_15_location_saves
    if @ride.update(
      pick_up_time: ride_params[:pick_up_time],
      reason: ride_params[:reason],
      start_location: start_location,
      end_location: end_location
    )
      flash.notice = 'The ride information has been updated'
      redirect_to ride_path(@ride)
    else
      render 'edit'
    end
  end

  def cancel
    @ride = Ride.find(params[:id])
    @ride.rider_id == current_rider.id
    if %w[pending approved scheduled].include? @ride.status
      @ride.update_attributes(status: 'canceled')
      @ride.token.update_attribute(:ride_id, nil)
      flash.notice = 'Ride canceled'
      redirect_to request.referrer || rides_path
    else
      flash.notice = 'Sorry the ride status is uncancellable.'
      redirect_to request.referrer || rides_path
    end
  end

  private

  def ride_params
    params.require(:ride).permit(:rider_id, :driver_id, :pick_up_time,
                                 :save_start_location, :start_street, :start_city, :start_state, :start_zip,
                                 :save_end_location, :end_street, :end_city, :end_state, :end_zip, :reason, :status)
  end

  # TODO: -- possibly clean out old record, and make a plan to fix it in the future.
  def save_location_error_handler(location)
    if !location.validate
      return nil
    end
    l_new = location.save_or_touch
    return l_new
  end

  # def update_location_error_handler(location)
  #   l_new = !location.save_or_touch
  #   if l_new.nil?
  #     flash.now[:alert] = location.errors.full_messages.join("\n")
  #     @ride = Ride.find(params[:id])
  #     render 'edit'
  #   end
  #   return l_new
  # end

  def rider_choose_save_location
    if ride_params[:save_start_location] == 'saved'
      lr1 = LocationRelationship.new(location_id: @start_location.id, rider_id: current_rider.id)
      lr1.save_or_touch
    end
    if ride_params[:save_end_location] == 'saved'
      lr2 = LocationRelationship.create(location_id: @end_location.id, rider_id: current_rider.id)
      lr2.save_or_touch
    end
  end

  def only_15_location_saves
    if (ride_params[:save_start_location] == 'saved') || (ride_params[:save_end_location] == 'saved')
      rider_location = current_rider.location_relationships.order(updated_at: :desc)
      if rider_location.count > 15
        (15..rider_location.count - 1).each do |i|
          rider_location[i].destroy
        end
      end
    end
  end

  def rider_not_authorized
    flash.notice = 'You are not authorized to view this information'
    redirect_to rides_path
  end

  def is_active_check
    unless current_rider.is_active?
      redirect_to rides_path
      flash.alert = "Sorry, you're deactivated."
    end
  end
end
