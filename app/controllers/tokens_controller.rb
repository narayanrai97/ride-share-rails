class TokensController < ApplicationController
  
  before_action :authenticate_user!
  layout "administration"

  def new
    @token = Token.new(:rider_id => params[:rider_id], :created_at => Time.now, :expires_at => Time.now + 1.month, :is_valid => true)
  end


  def show
    @token = Token.find(params[:id])
  end

  def index
    @tokens = Token.all
  end



  def create
    @token = Token.new(token_params)
    if @token.save
      redirect_to @token
    else
      render 'new'
    end
  end

  def edit
    @token = Token.find(params[:id])
  end

  def update
    @token = Token.find(params[:id])

    if @token.update(ride_params)
      flash.notice = "The token information has been updated"
      # redirect_to @token
      redirect_to token_path(@token)
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
    params.require(:token).permit(:rider_id, :created_at, :expires_at, :used_at, :valid)
  end


end
