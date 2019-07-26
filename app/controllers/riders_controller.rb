class RidersController < ApplicationController

  before_action :authenticate_user!
  layout "administration"

  def new
    @rider = Rider.new
  end

  def show
    @rider = Rider.find(params[:id])
    @count = Token.where(rider_id:  @rider.id).count
    @location_ids = LocationRelationship.where(rider_id: params[:id]).ids
    @locations = Location.where(id: @location_ids)

  end

  def index
    @riders = Rider.where(organization_id: current_user.organization_id)
  end

  def create
    @rider = Rider.new(rider_params)
    flash.notice = "The rider information has been created"
    @rider.organization_id = current_user.organization_id

    if @rider.save
      redirect_to @rider
    else
      render 'new'
    end
  end

  def edit
    @rider = Rider.find(params[:id])
  end

  def update
    @rider = Rider.find(params[:id])

    if @rider.update(rider_params)
      flash.notice = "The rider information has been updated"
      redirect_to @rider
    else
      render 'edit'
    end
  end

  private
  def rider_params
    params.require(:rider).permit(:first_name, :last_name, :phone, :email, :password, :password_confirmation)
  end

end
