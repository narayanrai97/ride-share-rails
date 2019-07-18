# frozen_string_literal: true
# limits admin access to admin only in Ride's organization
class RidePolicy < ApplicationPolicy
    def belongs_to_org?
      byebug
      # make sure user is an admin
      # current_ride.organization == current_user.organization ?
      ride.organization == current_user.organization
   end

    %i(show? edit? update? delete?).each do |ali|
      byebug
      alias_method ali, :belongs_to_org?  
    end
  end