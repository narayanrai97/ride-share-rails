class Ride < ApplicationRecord

  belongs_to :organization
  belongs_to :driver, optional: true
  belongs_to :rider
  belongs_to :start_location, :class_name => "Location", autosave: true
  belongs_to :end_location, :class_name => "Location", autosave: true
  has_one :token

  validates :pick_up_time, :reason, :status, presence: true
  validate :pick_up_time_cannot_be_in_the_past
  validate :valid_locations
  validates :status, inclusion: { in: %w(requested pending approved scheduled matched canceled picking-up dropping-off completed),
  message: "%{value} is not a valid status" }

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

  def pick_up_time_cannot_be_in_the_past
    if pick_up_time.present? && pick_up_time < Date.today
      errors.add(:pick_up_time, "can't be in the past")
    end
  end

end

