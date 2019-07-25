# This file can likely be deleted later.

# frozen_string_literal: true
# limits admin access to admin only in Ride's organization
# class UserPolicy < ApplicationPolicy
#     def user_belongs_to_org?
#       # byebug
#       record.organization == user.organization
#     end
      
#     %i(show? edit? update? delete?).each do |ali|
#       # byebug
#       alias_method ali, :user_belongs_to_org?
#     end
# end
