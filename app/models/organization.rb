class Organization < ApplicationRecord
  has_many :location_relationships
  has_many :location, -> { distinct }, through: :location_relationships
  has_many :drivers, dependent: :destroy
  has_many :riders, -> { distinct }, through: :location_relationships
  has_many :rides, dependent: :destroy
  has_many :tokens, through: :riders
  
  validates :name, :street, :city, :state, :zip, presence: true
  validates :use_tokens, inclusion: { in: [ true, false ] }
  
end
