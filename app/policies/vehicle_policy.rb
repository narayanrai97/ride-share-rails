# frozen_string_literal: true
# controls who can access disposal controller actions
class VehiclePolicy < ApplicationPolicy
    def vehicle_belongs_to_org?
      vehicle.driver.organization == current_user.organization
    end

    %i(edit? update? destroy?).each do |ali|
      alias_method ali, :vehicle_belongs_to_org?
    end
  end
