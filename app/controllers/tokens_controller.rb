class TokensController < ApplicationController

  before_action :authenticate_user!
  layout "administration"

  def new
    @rider = Rider.find(params[:rider_id])
    @token = @rider.tokens.new
  end

  def show
    @token = Token.find(params[:id])
  end

  def index
    @tokens = Token.all
  end

  private
    def token_params
      params.require(:token).permit(:rider_id, :created_at, :expires_at, :used_at, :is_valid)
    end

end
