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
      if result.length == 0 || !result.first.data["partial_match"].nil?
        errors[:base] << "The location could not be found."
      else # when partial_match is nil
        # Street number
        street_number = (result.first.data["address_components"].select { |address_hash| address_hash["types"] == ["street_number"]}).first
        if !street_number.nil?
          street_num = street_number["long_name"]
        else
          errors[:base] << "The street number could not be found."
        end
        # Street name
        route = (result.first.data["address_components"].select { |address_hash| address_hash["types"] == ["route"]}).first
        if !route.nil?
          street_name = route["short_name"]
        else
          errors[:base] << "The street name could not be found."
        end
        self.street = "#{street_num} #{street_name}" unless street_num.nil? && street_name.nil?

        # Suite number
        suite_number = (result.first.data["address_components"].select { |address_hash| address_hash["types"] == ["subpremise"]}).first
        if !suite_number.nil?
          self.street = self.street + " #" + suite_number["long_name"]
        else
          errors[:base] << "The suite number could not be found."
        end

        # City
        city = (result.first.data["address_components"].select { |address_hash|(address_hash["types"] == ["locality", "political"])}.first
        city = (result.first.data["address_components"].select { |address_hash|(address_hash["types"] == ["neighborhood", "political"])}.first if city.nil?
        if !city.nil?
          self.city = city["long_name"]
        else
          errors[:base] << "The city could not be found."
        end

        # State
        state = (result.first.data["address_components"].select { |address_hash| address_hash["types"] == ["administrative_area_level_1", "political"]}).first
        if !state.nil?
          self.state = state["short_name"]
        else
          errors[:base] << "The state could not be found."
        end

        # Zip
        zip = (result.first.data["address_components"].select { |address_hash| address_hash["types"] == ["postal_code"]}).first
        if !zip.nil?
          self.zip = zip["long_name"]
        else
          errors[:base] << "The zip code could not be found."
        end
      end
    end
  end
end
