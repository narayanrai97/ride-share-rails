# frozen_string_literal: true
# controls who can access disposal controller actions
class DriverPolicy < ApplicationPolicy
    def driver_or_up?

    end
  
    %i(show? edit? update? delete?).each do |ali|

       alias_method ali, :driver_or_up?  
    end
  end