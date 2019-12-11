class Location < ApplicationRecord

  has_many :location_relationships
  has_many :schedule_windows
  #One location would most likely have only one driver. But logic currently not that
  has_many :drivers,  -> { distinct }, through: :location_relationships
  has_many :riders, -> { distinct }, through: :location_relationships
  has_many :organizations, -> {distinct}, through: :location_relationships

  validates :street, :city, :state, :zip,  presence: true
  validates :zip, length: { is: 5 }, numericality: true
  validate :location_must_be_found
  geocoded_by :full_address
  after_validation :geocode, if: ->(obj) { obj.full_address.present? && obj.street_changed? }
  # after_validation :capitalize_first_letter, :upcase_fields
  # before_create :validate_location


  # def capitalize_first_letter
  #   if self.city
  #     self.city = self.city.split.map(&:capitalize).join(' ')
  #   end
  # end

  # def upcase_fields
  #   if state
  #     state.upcase!
  #   end
  # end

  def full_address
    sub_address = [street, city, state].compact.join(', ')
    [sub_address, zip].compact.join(' ')
  end

  def address_parsed
    self.to_json
  end

  def save_or_touch
    lr = Location.find_by(street: self.street, city: self.city, state: self.state, zip: self.zip)
    if !lr.nil?
      lr.touch
      return lr
    else
      result = self.save
      if result
        return self
      else
        return nil
      end
    end
  end

  def location_must_be_found
    if street.present? && city.present? && state.present? && zip.present?
      result = Geocoder.search(self.full_address)
      if !(result.length == 0 || result.first.data["partial_match"]).nil?
        errors[:base] << "The location could not be found."
      else
        street_number = (result.first.data["address_components"].select { |address_hash| address_hash["types"] == ["street_number"]}).first["long_name"]
        street_name = (result.first.data["address_components"].select { |address_hash| address_hash["types"] == ["route"]}).first["short_name"]
        self.street = "#{street_number} #{street_name}"
        suite_number = (result.first.data["address_components"].select { |address_hash| address_hash["types"] == ["subpremise"]}).first
        if !suite_number.nil?
          self.street = self.street + " #" + suite_number["long_name"]
        end
        self.city = (result.first.data["address_components"].select do |address_hash| 
          ((address_hash["types"] == ["locality", "political"]) || 
          (address_hash["types"] == ["neighborhood", "political"])) 
          end).first["long_name"]
        self.state = (result.first.data["address_components"].select { |address_hash| address_hash["types"] == ["administrative_area_level_1", "political"]}).first["short_name"]
        self.zip = (result.first.data["address_components"].select { |address_hash| address_hash["types"] == ["postal_code"]}).first["long_name"]
      end
    end
  end
end
