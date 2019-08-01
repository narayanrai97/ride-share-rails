# frozen_string_literal: true
# controls who can access disposal controller actions
class RiderPolicy < ApplicationPolicy
    def user_belongs_to_org?
      record.organization == user.organization
    end
  
    # %i(index? show? edit? update? delete?).each do |ali|
    %i(show? edit? update? delete?).each do |ali|
      alias_method ali, :user_belongs_to_org?
    end
  end