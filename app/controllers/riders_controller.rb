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
    if params[:status] == "pending"
      @rides = @rider.rides.pending
    elsif params[:status] == 'approved'
      @rides = @rider.rides.approved
    elsif params[:status] == 'canceled'
      @rides = @rider.rides.canceled
    elsif params[:status] == 'scheduled'
      @rides = @rider.rides.scheduled
    elsif params[:status] == 'picking-up'
      @rides = @rider.rides.picking_up
    elsif params[:status] == 'dropping-off'
      @rides = @rider.rides.dropping_off
    elsif params[:status] == 'completed'
      @rides = @rider.rides.completed
    else
      @rides = @rider.rides
    end
    @rider_rides = Kaminari.paginate_array(@rides).page(params[:page]).per(10)
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
    @rider.organization_id = current_user.organization_id

    if @rider.save
      flash.notice = "Rider created."
      redirect_to @rider
    else
      render 'new'
    end
  end

  def edit
    @rider = Rider.find(params[:id])
    authorize @rider
  end

  def update
    @rider = Rider.find(params[:id])
    authorize @rider

    if @rider.update_columns(first_name: params[:rider][:first_name],
                             last_name: params[:rider][:last_name],
                             phone: params[:rider][:phone],
                             email: params[:rider][:email])
      flash.notice = "The rider information has been updated"
      redirect_to @rider
    else
      render 'edit'
    end
  end

  def bulk_update
    @rider = Rider.find(params[:rider_id])
    authorize @rider

    quantity = params[:quantity].to_i
    if params[:commit] == "Add"
      add_bulk(@rider, quantity)
    elsif params[:commit] == "Remove"
      remove_bulk(@rider, quantity)
    end
  end

   def activation
    @rider = Rider.find(params[:rider_id])
    authorize @rider
    was_active = @rider.is_active
    @rider.toggle(:is_active).save
    if was_active == true
      flash.alert = "Rider deactivated."
    else
      flash.notice = "Rider reactivated."
    end
    redirect_to request.referrer || riders_path
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
      redirect_to request.referrer || riders_path
    end

    def remove_bulk(rider, quantity)
      previous_count = rider.valid_tokens.count
      tokens = rider.valid_tokens.limit(quantity)
      if rider.valid_tokens_count > 0
        tokens.update_all(is_valid: false)
        diff = previous_count - rider.valid_tokens.count
        flash.notice = "#{diff} #{'token'.pluralize(diff)} removed."
        redirect_to request.referrer || riders_path
      else
        flash.notice = "Rider does not have any valid tokens"
        redirect_to request.referrer || riders_path
      end
    end
end
