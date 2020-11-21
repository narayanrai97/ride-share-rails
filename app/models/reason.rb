class Reason < ApplicationRecord
  belongs_to :ride
  belongs_to :ride_category
  validates_presence_of :ride
  validates_presence_of :ride_category
end
