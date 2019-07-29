class TokensController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_token_belongs_to_org!, only: [:show, :update, :edit, :delete]
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

  def create
    @rider = Rider.find(params[:token][:rider_id])
    @quantity = params[:token][:quantity].to_i

    @counter = 0
    @quantity.times do
      if @rider.valid_tokens.create
        @counter += 1
      end
    end

    flash.notice = "#{@counter} #{'token'.pluralize(@counter)} given to #{@rider.full_name}"
    redirect_to rider_path(@rider)
  end

  def edit
    @rider = Rider.find(params[:rider_id])
    @token = @rider.valid_tokens
  end

  def update
    @rider = Rider.find(params[:token][:rider_id])
    @tokens = @rider.valid_tokens

    if @token.update(token_params)
      flash.notice = "The token information has been updated"
      redirect_to @token
    else
      render 'edit'
    end
  end

  def destroy
    @token = Token.find(params[:id])
    @token.destroy

    redirect_to tokens_path
  end

  private
  def token_params
    params.require(:token).permit(:rider_id, :created_at, :expires_at, :used_at, :is_valid)
  end

  def authorize_token_belongs_to_org!
    byebug
    authorize Token
  end

end
