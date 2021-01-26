class AdminRide::CancellationReasonsController < ApplicationController
  def review
    @ride = Ride.find(params[:id])
  end

  def cancel
    @ride = Ride.find(params[:id])
    authorize @ride
    if %w[pending approved scheduled].include? @ride.status
      @ride.update_attributes(status: 'canceled', cancellation_reason: params[:ride][:cancellation_reason])
      @ride.token&.update_attribute(:ride_id, nil)
      flash.notice = 'Ride canceled.'
      redirect_to request.referrer || admin_ride_index_path
    end
  end
end
