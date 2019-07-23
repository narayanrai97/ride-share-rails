# frozen_string_literal: true
# controls who can access disposal controller actions
class TokenPolicy < ApplicationPolicy
    def token_belongs_to_org?
      byebug
      token.organization == current_user.organization

    end
  
    %i(show? edit? update? delete?).each do |ali|
      byebug
      alias_method ali, :token_or_up?  
    end
  end
