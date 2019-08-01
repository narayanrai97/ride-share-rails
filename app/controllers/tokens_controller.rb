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

  def bulk_form
    @rider = Rider.find(params[:rider_id])
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
      previous_count = rider.valid_tokens.count
      quantity.times { rider.valid_tokens.create }
      diff = rider.valid_tokens.count - previous_count
      flash.notice = "#{diff} #{'Token'.pluralize(diff)} given to #{rider.full_name}."
      redirect_to request.referrer

    end

    def remove_bulk(rider, quantity)
      previous_count = rider.valid_tokens.count
      tokens = rider.valid_tokens.limit(quantity)
      if rider.valid_tokens_count > 0
        tokens.update_all(is_valid: false)
        diff = previous_count - rider.valid_tokens.count
        flash.notice = "#{diff} #{'Token'.pluralize(diff)} taken away from #{rider.full_name}."
        redirect_to request.referrer
      else
        flash.notice = "Rider does not have any valid token."
        redirect_to request.referrer
      end
    end
end
