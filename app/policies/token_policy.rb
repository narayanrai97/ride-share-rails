# frozen_string_literal: true
# controls who can access disposal controller actions
class TokenPolicy < ApplicationPolicy
    def token_or_up?

    end
  
    %i(show? edit? update? delete?).each do |ali|

       alias_method ali, :token_or_up?  
    end
  end