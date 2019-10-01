class Ride < ApplicationRecord

  belongs_to :organization
  belongs_to :driver, optional: true
  belongs_to :rider
  belongs_to :start_location, :class_name => "Location", autosave: true
  belongs_to :end_location, :class_name => "Location", autosave: true
  has_many :location
  has_one :token

  validates :pick_up_time, :reason, :status, presence: true
  validate :pick_up_time_cannot_be_in_the_past
  validate :valid_locations
  validates :status, inclusion: { in: %w(pending approved scheduled picking-up dropping-off completed canceled),
  message: "%{value} is not a valid status" }

  scope :approved, -> { where(status: "approved") }
  scope :canceled, -> { where(status: "canceled") }
  scope :pending, -> { where(status: "pending") }
  scope :scheduled, -> { where(status: "scheduled") }
  scope :picking_up, -> { where(status: "picking-up") }
  scope :dropping_off, -> { where(status: "dropping-off") }
  scope :completed, -> { where(status: "completed") }

  # validate that start_location and end_location are valid
  def valid_locations
    if start_location.present? && !start_location.valid?
      errors.add(:start_location, " is not valid")
    end
    if end_location.present? && !end_location.valid?
      errors.add(:end_location, " is not valid")
    end
  end

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

end

