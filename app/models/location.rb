class Location < ApplicationRecord
  has_many :location_relationships
  has_many :schedule_windows
  #One location would most likely have only one driver. But logic currently not that
  has_many :drivers, through: :location_relationships
end
