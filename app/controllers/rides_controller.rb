class RidesController < ApplicationController

    def new
      @ride = Ride.new
    end


    def show
      @ride = Ride.find(params[:id])
      @start_location = Location.find(@ride.start_location_id)
      @end_location = Location.find(@ride.end_location_id)
    end

    def index
      @rides = Ride.all
    end



    def create
      @ride = Ride.new(ride_params)

      if @ride.save
        redirect_to @ride
      else
        render 'new'
      end
    end

    def edit
      @ride = Ride.find(params[:id])
    end

    def update
      @ride = Ride.find(params[:id])

      if @ride.update(ride_params)
        redirect_to @ride
      else
        render 'edit'
      end
    end

    def destroy
      @ride = Ride.find(params[:id])
      @ride.destroy

      redirect_to rides_path
    end



    private
    def ride_params
      params.require(:ride).permit(:rider_id, :driver_id, :pick_up_time, :start_street, :start_city, :start_state, :start_zip, :end_street, :end_city, :end_state, :end_zip, :reason, :status)
    end

end


