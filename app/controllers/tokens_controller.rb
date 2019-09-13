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
    authorize Token
  end

  def index
    @tokens = Token.all
  end

  private
    def token_params
      params.require(:token).permit(:rider_id, :created_at, :expires_at, :used_at, :is_valid)
    end

    def authorize_token_belongs_to_org!
      authorize Token
    end

    # I think the following two methods were moved to the
    # riders controller.. just didn't want to delete preemptively
    # without knowing for sure.

    # def add_bulk(rider, quantity)
    #   previous_count = rider.valid_tokens.count
    #   quantity.times { rider.valid_tokens.create }
    #   diff = rider.valid_tokens.count - previous_count
    #   flash.notice = "#{diff} #{'Token'.pluralize(diff)} given to #{rider.full_name}."
    #   redirect_to request.referrer
    # end
    #
    # def remove_bulk(rider, quantity)
    #   previous_count = rider.valid_tokens.count
    #   tokens = rider.valid_tokens.limit(quantity)
    #   if rider.valid_tokens_count > 0
    #     tokens.update_all(is_valid: false)
    #     diff = previous_count - rider.valid_tokens.count
    #     flash.notice = "#{diff} #{'Token'.pluralize(diff)} taken away from #{rider.full_name}."
    #     redirect_to request.referrer
    #   else
    #     flash.notice = "Rider does not have any valid token."
    #     redirect_to request.referrer
    #   end
    # end
end
