class Reason < ApplicationRecord
  belongs_to :ride
  belongs_to :ride_category, optional: true
  belongs_to :cancellation_reason, optional: true
  validates_presence_of :ride
  # validates_presence_of :ride_category
end
