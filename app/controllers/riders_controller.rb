class RidersController < ApplicationController

  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  layout "administration"

  def new
    @rider = Rider.new
  end

  def show
    @rider = Rider.find(params[:id])
    authorize @rider
    @location_ids = LocationRelationship.where(rider_id: params[:id]).ids
    @locations = Location.where(id: @location_ids)
  end

  def index
    @riders = current_user.organization.riders.order(last_name: :desc)
    @riders = Kaminari.paginate_array(@riders).page(params[:page]).per(10)
  end

  def sort_down
    @riders = current_user.organization.riders.order(:last_name)
    @riders = Kaminari.paginate_array(@riders).page(params[:page]).per(10)
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

  def bulk_update
    @rider = Rider.find(params[:rider_id])
    quantity = params[:quantity].to_i
    if params[:commit] == "Add"
      add_bulk(@rider, quantity)
    elsif params[:commit] == "Remove"
      remove_bulk(@rider, quantity)
    end
  end

  private
    def rider_params
      params.require(:rider).permit(:first_name, :last_name, :phone, :email, :password, :password_confirmation)
    end

    def user_not_authorized
        flash.notice = "You are not authorized to view this information"
        redirect_to riders_path
    end

    def add_bulk(rider, quantity)
      previous_count = rider.valid_tokens.count
      quantity.times { rider.valid_tokens.create }
      diff = rider.valid_tokens.count - previous_count
      flash.notice = "#{diff} #{'token'.pluralize(diff)} added."
      redirect_to request.referrer

    end

    def remove_bulk(rider, quantity)
      previous_count = rider.valid_tokens.count
      tokens = rider.valid_tokens.limit(quantity)
      if rider.valid_tokens_count > 0
        tokens.update_all(is_valid: false)
        diff = previous_count - rider.valid_tokens.count
        flash.notice = "#{diff} #{'token'.pluralize(diff)} removed."
        redirect_to request.referrer
      else
        flash.notice = "Rider does not have any valid token."
        redirect_to request.referrer
      end
    end

end
