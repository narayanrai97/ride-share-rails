class Location < ApplicationRecord

  has_many :location_relationships
  has_many :schedule_windows
  #One location would most likely have only one driver. But logic currently not that
  has_many :drivers,  -> { distinct }, through: :location_relationships
  has_many :riders, -> { distinct }, through: :location_relationships
  has_many :organizations, -> {distinct}, through: :location_relationships  
  
  validates :street, :city, :state, :zip, presence: true
  validates :zip, length: { is: 5 }, numericality: true
  geocoded_by :full_address
  after_validation :geocode, if: ->(obj) { obj.full_address.present? && obj.street_changed? }
  after_validation :capitalize_first_letter, :upcase_fields
  before_create :validate_location


  def capitalize_first_letter
    if self.city
      self.city = self.city.split.map(&:capitalize).join(' ')
    end
  end

  def upcase_fields
    if state
      state.upcase!
    end
  end

  def full_address
    sub_address = [street, city, state].compact.join(', ')
    [sub_address, zip].compact.join(' ')
  end

  def address_parsed
    self.to_json
  end


  def validate_location
    if self.present?
      result = Geocoder.search(self.full_address)
      if result.length == 0 || result.first.data["partial_match"] == true
        errors.add(:location, "is invalid.")
      end
    end
  end
end
