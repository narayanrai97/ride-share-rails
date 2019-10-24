class Organization < ApplicationRecord
  has_many :location_relationships
  has_many :location, -> { distinct }, through: :location_relationships
  has_many :drivers, dependent: :destroy
  has_many :riders, -> { distinct }, through: :location_relationships
  has_many :start_rides, class_name: 'Ride', foreign_key: 'start_location_id'
  has_many :end_rides, class_name: 'Ride', foreign_key: 'end_location_id'
  has_many :rides, dependent: :destroy
  has_many :tokens, through: :riders
  
  validates :name, :street, :city, :state, :zip, presence: true
  validates :use_tokens, inclusion: { in: [ true, false ] }
  
end
