class TokensController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_token_belongs_to_org!, only: [:index, :show]
  layout "administration"

  def show
    @token = Token.find(params[:id])
  end

  def index
    @tokens = Token.all
  end

  private
    def authorize_token_belongs_to_org!
      authorize Token
    end

end
