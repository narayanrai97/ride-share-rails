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

  def create
    @rider = Rider.find(params[:token][:rider_id])
    @quantity = params[:token][:quantity].to_i

    @quantity.times do
      if @rider.valid_tokens.create

      else
        render 'new'
      end
    end

    flash.notice = "#{@quantity} #{'token'.pluralize(@quantity)} given to #{@rider.full_name}"
    redirect_to rider_path(@rider)
  end

  def edit
    @token = Token.find(params[:id])
  end

  def update
    @token = Token.find(params[:id])

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

end
