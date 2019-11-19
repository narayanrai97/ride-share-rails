class Ride < ApplicationRecord

  belongs_to :organization
  belongs_to :driver, optional: true
  belongs_to :rider
  belongs_to :start_location, :class_name => "Location"
  belongs_to :end_location, :class_name => "Location"
  has_one :token

  validates :start_location, :end_location, :pick_up_time, :reason, :status, presence: true
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
    if start_location.present? #start location validation
      result1 = Geocoder.search(start_location.full_address)
      if result1.length == 0 || result1.first.data["partial_match"] == true
        errors.add(:start_location, "is invalid.")
      else
        zipcode = result1.first.data["address_components"].select { |address_hash| address_hash["types"] == ["postal_code"] }
        start_location.zip = zipcode.first["long_name"]
      end
    end

    if end_location.present? #end locaiton validation
      result2 = Geocoder.search(end_location.full_address)
      if result2.length == 0 || result2.first.data["partial_match"] == true
        errors.add(:end_location, "is invalid.")
      else
        zipcode = result2.first.data["address_components"].select { |address_hash| address_hash["types"] == ["postal_code"] }
        end_location.zip = zipcode.first["long_name"]
      end
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

end
