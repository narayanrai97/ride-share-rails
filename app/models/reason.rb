class Reason < ApplicationRecord
  belongs_to :ride
  belongs_to :ride_category
end
