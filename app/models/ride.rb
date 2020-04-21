class Ride < ApplicationRecord
  belongs_to :organization
  belongs_to :driver, optional: true
  belongs_to :rider
  belongs_to :start_location, :class_name => "Location"
  belongs_to :end_location, :class_name => "Location"
  has_one :token

  validates :start_location, :end_location, :pick_up_time, :reason, :status, presence: true
  validate :pick_up_time_cannot_be_in_the_past
  # validate :valid_locations
  validates :status, inclusion: { in: %w(pending approved scheduled picking-up dropping-off waiting return-picking-up return-dropping-off completed canceled),
  message: "%{value} is not a valid status" }
  # validates :expected_wait_time, presence: true, if: :round_trip?
  after_validation :set_distance, on: [ :create, :update ]
  scope :status, -> (status) { where status: status }

  def start_street
    if self.start_location
      self.start_location.street
    else
      nil
    end
  end

  def end_street
    if self.end_location
      self.end_location.street
    else
      nil
    end
  end

  def start_city
    if self.end_location
      self.end_location.city
    else
      nil
    end
  end

  def start_state
    if self.start_location
      self.start_location.state
    else
      nil
    end
  end

  def start_zip
    if self.start_location
      self.start_location.zip
    else
      nil
    end
  end

  def start_zip
    if self.start_location
      self.start_location.zip
    else
      nil
    end
  end

  def end_city
    if self.end_location
      self.end_location.city
    else
      nil
    end
  end

  def end_state
    if self.end_location
      self.end_location.state
    else
      nil
    end
  end

  def end_zip
    if self.end_location
      self.end_location.zip
    else
      nil
    end
  end

  def pick_up_time_cannot_be_in_the_past
    if ['pending', 'approved', 'scheduled'].include? self.status
      if pick_up_time.present? && pick_up_time < Date.today
        errors.add(:pick_up_time, "can't be in the past")
      end
    end
  end

  def is_near?(position,radius)
   start_distance = self.start_location.distance_from(position)
   if start_distance.nil? || start_distance > radius
     return false
   end
   end_distance = self.end_location.distance_from(position)
    if end_distance.nil? || end_distance > radius
     return false
    end
      return true
  end

  def distance
    geodistance = Geodistance.new(self.start_location, self.end_location)
    geodistance.calculate_distance # calculate_distance method called from Geodistance helper method
  end

  def set_distance
    self.pick_up_to_drop_off_distance = self.distance
  end

end
