class Location < ApplicationRecord
  has_many :location_relationships
  has_many :schedule_windows

end
