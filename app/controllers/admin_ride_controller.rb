class AdminRideController < ApplicationController

  before_action :authenticate_user!
  layout 'administration'

  def new
    @ride = Ride.new
  end

  def show
    @ride = Ride.find(params[:id])
  end

  def index
    @rides = Ride.all
  end

  def create
    rider = Rider.find(ride_params[:rider_id])
    token = rider.next_valid_token
    token = rider.valid_tokens.create if token.nil?

    start_location = Location.new(street: ride_params[:start_street],
                                   city: ride_params[:start_city],
                                   state: ride_params[:start_state],
                                   zip: ride_params[:start_zip])

    end_location = Location.new(street: ride_params[:end_street],
                                 city: ride_params[:end_city],
                                 state: ride_params[:end_state],
                                 zip: ride_params[:end_zip])

    @ride = rider.rides.new(organization_id: current_user.organization_id,
                            pick_up_time: ride_params[:pick_up_time],
                            start_location: start_location,
                            end_location: end_location,
                            reason: ride_params[:reason])
    @ride.update_attribute(:status, "approved") if current_user.organization.use_tokens?

    if @ride.save
      token.ride_id = @ride.id
      token.save
      flash[:notice] = "Ride created for #{rider.full_name}"
      redirect_to admin_ride_path(@ride)
    else
      render 'new'
    end
  end

  def edit
    @ride = Ride.find(params[:id])
  end

  def update
    @ride = Ride.find(params[:id])
    @start_location = @ride.start_location
    @end_location = @ride.end_location
    start_location = {street: ride_params[:start_street],
                      city: ride_params[:start_city],
                      state: ride_params[:start_state],
                      zip: ride_params[:start_zip]}

    end_location = {street: ride_params[:end_street],
                    city: ride_params[:end_city],
                    state: ride_params[:end_state],
                    zip: ride_params[:end_zip]}

    if !@start_location.update(start_location)
      flash.now[:alert] = @start_location.errors.full_messages.join(", ")
      render 'edit' and return
    end

    if !@end_location.update(end_location)
      flash.now[:alert] = @end_location.errors.full_messages.join(", ")
      render 'edit' and return
    end

    if @ride.update(
      organization_id: current_user.organization_id,
      rider_id: ride_params[:rider_id],
      pick_up_time: ride_params[:pick_up_time],
      reason: ride_params[:reason])
      flash.notice = "The ride information has been updated"
      redirect_to admin_ride_path(@ride)
    else
      render 'edit'
    end
  end

  def approve
    Ride.find(params[:id]).update_attribute(:status, "approved")
    flash.notice = "Ride approved."
    redirect_to request.referrer || admin_ride_index_path
  end

  def reject
    Ride.find(params[:id]).update_attribute(:status, "rejected")
    flash.notice = "Ride rejected."
    redirect_to request.referrer || admin_ride_index_path
  end



  private

    def ride_params
      params.require(:ride).permit(:rider_id, :driver_id, :pick_up_time,
        :start_street, :start_city, :start_state, :start_zip,
        :end_street, :end_city, :end_state, :end_zip, :reason, :status)
    end
end


