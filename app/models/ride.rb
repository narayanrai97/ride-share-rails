class Ride < ApplicationRecord
  belongs_to :organization
  belongs_to :driver, optional: true
  belongs_to :rider
  belongs_to :start_location, :class_name => "Location"
  belongs_to :end_location, :class_name => "Location"
  has_one :token

  validates :pick_up_time, :reason, :status, presence: true
  validate :pick_up_time_cannot_be_in_the_past
  validates :status, inclusion: { in: %w(requested pending approved scheduled matched canceled picking-up dropping-off completed),
                                  message: "%{value} is not a valid status" }

  # has_many :locations

  def pick_up_time_cannot_be_in_the_past
    if pick_up_time.present? && pick_up_time < Date.today
      errors.add(:pick_up_time, "can't be in the past")
    end
  end

end
