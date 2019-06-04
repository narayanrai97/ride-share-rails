class WelcomeController < ApplicationController
  layout false
  layout 'application', :only => :index
  layout 'rider_layout', :only => :rider
  layout false, :only => :welcome
  
  def welcome
  
  end

  def rider

  end

  def index

  end
end
