# frozen_string_literal: true
# limits admin access to admin only in Ride's organization
class RidePolicy < ApplicationPolicy
    def ride_belongs_to_org?
      byebug
      ride.organization == current_user.organization
   end

    %i(show? edit? update? delete?).each do |ali|
      byebug
      alias_method ali, :ride_belongs_to_org?  
    end
  end