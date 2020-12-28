class AdminRide::RideCancellationsController < ApplicationController
  def review
    @ride = Ride.find(params[:id])
    @cancellation_reasons = CancellationReason.where(organization_id: current_user.organization_id)
    authorize @ride
    # authorize @cancellation_reasons
  end

  def cancel
    @ride = Ride.find(params[:id])
    authorize @ride
    if %w[pending approved scheduled].include? @ride.status
      @ride.update_attributes(status: 'canceled')
      @ride.token&.update_attribute(:ride_id, nil)
      flash.notice = 'Ride canceled.'
      redirect_to admin_ride_index_path
    end
  end
end
