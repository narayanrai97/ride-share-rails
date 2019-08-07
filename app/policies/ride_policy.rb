# frozen_string_literal: true
# limits admin access to admin only in Ride's organization
class RidePolicy < ApplicationPolicy

  def initialize(client, ride)
    @client = client
    @ride = ride
  end

  def ride_belongs_to_rider?
    if @client.class == User
      return @ride.organization == @client.organization
    elsif @client.class == Rider
      return @ride.rider_id == @client.id
    # I will likely be adding a flash message in the code below.
    # else
      # flash.notice = "Unknown client"
      # return false
    end

  end
    
  %i(show? edit? update? delete?).each do |ali|
    alias_method ali, :ride_belongs_to_rider?
  end
end
