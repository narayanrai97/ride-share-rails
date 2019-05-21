class OrganizationsController < ApplicationController


  def new
    @organization = Organization.new
  end

  def show
    @organization = Organization.find(params[:id])
    @location_ids = LocationRelationship.where(rider_id: params[:id]).ids
    @locations = Location.where(id: @location_ids)

  end

  def index
    @organizations = Organization.all
  end

  def create
    @organization = Organization.new(org_params)

    if @organization.save
      redirect_to @organization
    else
      render 'new'
    end
  end


  def edit
    @organization = Organization.find(params[:id])
  end

  def update
    @organization = Organization.find(params[:id])

    if @organization.update(org_params)
      redirect_to @organization
    else
      render 'edit'
    end
  end




  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    redirect_to organizations_path
  end

  private
  def org_params
    params.require(:organization).permit(:name, :street, :state, :city, :zip)
  end

end
