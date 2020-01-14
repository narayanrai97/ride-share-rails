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
    if (current_rider)
      redirect_to rides_path
    end
  end

  def index
    if (current_user)
      redirect_to admin_ride_index_path
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
