class AdminRide::RideCancellationsController < ApplicationController
  def review
    @ride = Ride.find(params[:id])
    @cancellation_categories = CancellationCategory.where(organization_id: current_user.organization_id)
    authorize @ride
    # authorize @cancellation_categories
  end

  def cancel
    @ride = Ride.find(params[:id])
    authorize @ride
    if %w[pending approved scheduled].include? @ride.status
      @ride.update_attributes(status: 'canceled')
      @ride.token&.update_attribute(:ride_id, nil)
      if @ride.update(reasons_attributes: ride_params[:reasons_attributes])
        flash.notice = 'Ride canceled.'
        redirect_to admin_ride_index_path
      end
    end
  end

  def ride_params
    params.require(:ride).permit(reasons_attributes: [:details, :ride_category_id, :cancellation_category_id, :_destroy, :id])
  end
end
