class Location < ApplicationRecord
  has_many :location_relationships
  has_many :schedule_windows
  #One location would most likely have only one driver. But logic currently not that
  has_many :drivers, through: :location_relationships
  geocoded_by :full_address
  validates :street, :city, :state, :zip, presence: true
  validates :zip, length: { is: 5 }, numericality: true
  after_validation :geocode, if: ->(obj) { obj.full_address.present? && obj.street_changed? }
  after_validation :capitalize_first_letter, :upcase_fields


  def capitalize_first_letter
    if self.city
      self.city = self.city.split.map(&:capitalize).join(' ')
    end
  end
  
  def full_address
    sub_address = [address, city, state].compact.join(', ')
    [sub_address, zipcode].compact.join(' ')
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
end
