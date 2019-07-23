# frozen_string_literal: true
# controls who can access disposal controller actions
class RiderPolicy < ApplicationPolicy
    def rider_belongs_to_org
      byebug
      rider.organization == current_user.organization
    end
  
    %i(show? edit? update? delete?).each do |ali|
      byebug
      alias_method ali, :rider_belongs_to_org?
    end
  end