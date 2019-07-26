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

    flash.notice = "#{@quantity} #{'token'.pluralize(@quantity)} given to #{@rider.full_name}."
    redirect_to rider_path(@rider)
  end

  def edit
    @rider = Rider.find(params[:id])
    @token = @rider.valid_tokens.first
  end

  def update
    @rider = Rider.find(params[:token][:rider_id])
    @tokens_array = @rider.valid_tokens.to_a
    @quantity = params[:token][:quantity].to_i
    @counter = 0

    @tokens_array.each_with_index do |value, index|
      if index < @quantity
        value.update_attributes(is_valid: false)
        @counter += 1
      end
    end

    flash.notice = "#{@counter} #{'Token'.pluralize(@counter)} taken away from #{@rider.full_name}."
    redirect_to @rider
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
