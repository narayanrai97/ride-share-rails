class ApplicationController < ActionController::Base
	# before_action :authenticate_organization!

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password,
    :password_confirmation, :first_name, :last_name, :phone, :organization_id])
  end

end
