class Ride < ApplicationRecord
  belongs_to :organization
  belongs_to :driver, optional: true
  belongs_to :rider
  belongs_to :start_location, :class_name => "Location"
  belongs_to :end_location, :class_name => "Location"
  has_one :token

  validates :rider_id, presence:true

  # has_many :locations

end
