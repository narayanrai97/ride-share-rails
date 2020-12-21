class Reason < ApplicationRecord
  belongs_to :ride
  belongs_to :ride_category
  # belongs_to :cancellation_reason
  validates_presence_of :ride
  validates_presence_of :ride_category
end
