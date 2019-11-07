# frozen_string_literal: true
# controls who can access disposal controller actions
class RiderPolicy < ApplicationPolicy
    def user_belongs_to_org?
      record.organization == user.organization
    end

    %i(show? edit? update? delete? bulk_update? activation? create?).each do |ali|
      alias_method ali, :user_belongs_to_org?
    end
  end
