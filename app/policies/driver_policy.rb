# frozen_string_literal: true
# controls who can access disposal controller actions
class DriverPolicy < ApplicationPolicy
    def user_belongs_to_org?
      record.organization == user.organization
    end

    %i(show? edit? update? reject? pass? fail?).each do |ali|
      alias_method ali, :user_belongs_to_org?
    end
  end
