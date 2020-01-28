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
    # byebug
    @ride = Kaminari.paginate_array(@ride).page(params[:par]).per(5)
    @drivers = Driver.where(organization_id: current_user.organization.id).pending
    # byebug
    @drivers = Kaminari.paginate_array(@drivers).page(params[:fan]).per(5)
    if (!current_user)
      redirect_to welcome_welcome_path
    end
  end

  private

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
