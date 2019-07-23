# frozen_string_literal: true
# controls who can access disposal controller actions
class DriverPolicy < ApplicationPolicy
    def driver_belongs_to_org?
      byebug
      driver.organization == current_user.organization
    end
  
    %i(show? edit? update? delete?).each do |ali|
      byebug
      alias_method ali, :driver_belongs_to_org?  
    end
  end