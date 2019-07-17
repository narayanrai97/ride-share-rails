# frozen_string_literal: true
# controls who can access disposal controller actions
class RidePolicy < ApplicationPolicy
    def ride_or_up?

    end

    %i(show? edit? update? delete?).each do |ali|

       alias_method ali, :ride_or_up?  
    end
  end