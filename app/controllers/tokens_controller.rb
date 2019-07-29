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

  def edit
    @rider = Rider.find(params[:id])
    @token = @rider.valid_tokens.first if !@rider.valid_tokens.nil?
  end

  def destroy
    @token = Token.find(params[:id])
    @token.destroy

    redirect_to tokens_path
  end



  def bulk_form
  end

  def bulk_update
    rider = Rider.find(params[:rider_id])
    quantity = params[:quantity].to_i

    if params[:commit] == "Add"
      add_bulk(rider, quantity)
    elsif params[:commit] == "Remove"
      remove_bulk(rider, quantity)
    end
  end

  private
  def token_params
    params.require(:token).permit(:rider_id, :created_at, :expires_at, :used_at, :is_valid)
  end

  def add_bulk(rider, quantity)
    quantity.times { rider.valid_tokens.create }
    flash.notice = "#{quantity} #{'token'.pluralize(quantity)} given to #{rider.full_name}"
    redirect_to rider
  end

  def remove_bulk(rider, quantity)
    tokens = rider.valid_tokens.limit(quantity)
    tokens.update_all(is_valid: false)

    flash.notice = "#{quantity} #{'Token'.pluralize(quantity)} taken away from #{rider.full_name}."
    redirect_to rider
  end
end
