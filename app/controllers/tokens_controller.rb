class TokensController < ApplicationController

  before_action :authenticate_user!
  layout "administration"

  def show
    @token = Token.find(params[:id])
    authorize @token
  end

  def index
    @tokens = Token.all #I'm leaving as is now. We'll need to modify it later!
  end

end
