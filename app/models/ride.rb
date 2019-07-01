class Ride < ApplicationRecord
  belongs_to :organization
  belongs_to :driver, optional: true
  belongs_to :rider
  belongs_to :start_location, :class_name => "Location"
  belongs_to :end_location, :class_name => "Location"
  has_one :token

  validates :pick_up_time, :reason, :status, presence: true
  validates :organization, :driver, :rider, :start_location, :end_location, presence: true
  validates :status, inclusion: { in: %w(requested pending approved scheduled matched completed),
            message: "%{value} is not a valid status" }
 

  # has_many :locations

end
