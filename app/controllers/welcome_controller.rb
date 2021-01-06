class WelcomeController < ApplicationController
  layout :resolve_layout
  before_action :current_year_ride_count, only: :index
  before_action :current_day_ride_count, only: :index

  def welcome
    if (current_user)
      redirect_to welcome_index_path
    # else
    #   redirect_to welcome_rider_path
    end
  end

  def rider
    if (current_rider)
      redirect_to rides_path
    end
  end

  def index
    @rides = Ride.where("organization_id =? AND pick_up_time >=?", current_user.organization.id, Date.today).status("pending").order(:pick_up_time)
    @rides = Kaminari.paginate_array(@rides).page(params[:page]).per(5)
    @approved_rides = Ride.where("organization_id =? AND pick_up_time >=?", current_user.organization.id, Date.today).status("approved").order(:pick_up_time)
    @drivers = Driver.where(organization_id: current_user.organization.id).pending.order(:created_at)
    # @rides_completed_this_year = current_year_ride_count
    @drivers = Kaminari.paginate_array(@drivers).page(params[:page]).per(5)
    # @rides_completed_today = current_day_ride_count
    if (!current_user)
      redirect_to welcome_welcome_path
    end
  end

  def driver
    redirect_to welcome_welcome_path
    flash.notice = "Your password has been reset, Please log in on the app."
  end


  private

  def current_year_ride_count
    start_day = Date.today.beginning_of_year
    end_day =  Date.today.end_of_year
    Ride.where("completed_at >= ? AND organization_id = ? AND completed_at <= ? ", start_day, current_user.organization.id, end_day).count
  end

  def current_day_ride_count
    Ride.where(organization_id: current_user.organization.id, status: "completed", completed_at: Date.today).count
  end

  def resolve_layout
    case action_name
    when "rider"
      "rider_layout"
    when "index"
      "administration"
    else
      "application"
    end
  end

end
