# frozen_string_literal: true
# controls who can access disposal controller actions
class RiderPolicy < ApplicationPolicy
    def rider_or_up?

    end
  
    %i(show? edit? update? delete?).each do |ali|

       alias_method ali, :rider_or_up?  
    end
  end