class VehiclesController < ApplicationController
  def new
    @driver = Driver.find(params[:driver_id])
    @vehicle = Vehicle.new
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.driver_id= params[:driver_id]
    if @vehicle.save
      flash.notice = "The vehicle information has been created"
      redirect_to driver_path(params[:driver_id])
    else
      flash.alert = @vehicle.errors.full_messages.join(' ')
      redirect_to driver_path(params[:driver_id])
    end
  end

  def edit
    @vehicle = Vehicle.find(params[:id])
    authorize @vehicle
  end

  def update
    @vehicle = Vehicle.find(params[:id])
    authorize @vehicle
    if @vehicle.update(vehicle_params)
      flash.notice = "The vehicle information has been updated"
      redirect_to driver_path(@vehicle.driver_id)
    else
      render "edit"
    end
  end

  def destroy
    @vehicle = Vehicle.find(params[:id])
    authorize @vehicle
    @vehicle.destroy
    redirect_to driver_path(@vehicle.driver_id)
  end

  private
  def vehicle_params
    params.require(:vehicle).permit(:car_make, :car_model,
       :car_color, :car_year,:car_plate, :seat_belt_num, :insurance_provider,
     :insurance_start, :insurance_stop)
  end
end
