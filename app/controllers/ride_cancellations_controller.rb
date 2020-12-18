class RideCancellationsController < ApplicationController
  def show
  # byebug
    @ride = Ride.find(params[:id])
  end
end
