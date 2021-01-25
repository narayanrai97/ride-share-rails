class AdminRide::CancellationReasonsController < ApplicationController
  def review
    @ride = Ride.find(params[:id])
  end

  def cancel
    @ride = Ride.find(params[:id])
  end
end
