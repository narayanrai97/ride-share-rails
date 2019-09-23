class TokensController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  layout "administration"

  def show
    @token = Token.find(params[:id])
    authorize @token
  end

  def index
    @tokens = current_user.organization.tokens
    @tokens = Kaminari.paginate_array(@tokens).page(params[:page]).per(10)
  end

  private

  def user_not_authorized
    flash.notice = "You are not authorized to view this information"
    redirect_to tokens_path
  end
end
