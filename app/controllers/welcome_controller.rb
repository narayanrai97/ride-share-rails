class WelcomeController < ApplicationController
  layout :resolve_layout

  def welcome
    if (current_user)
      redirect_to welcome_index_path
    elsif (current_rider)
      redirect_to welcome_rider_path
    end
  end

  def rider
    if (!current_rider)
      redirect_to welcome_welcome_path
    end
  end

  def index
    @ride = Ride.where(organization_id: current_user.organization.id).pending
    @ride = Kaminari.paginate_array(@ride).page(params[:page]).per(5)
    @drivers = Driver.where(organization_id: current_user.organization.id).pending
    @rides_completed_this_year = current_year_ride_count
    @drivers = Kaminari.paginate_array(@drivers).page(params[:page]).per(5)
    @rides_completed_today = current_day_ride_count
    if (!current_user)
      redirect_to welcome_welcome_path
    end
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
