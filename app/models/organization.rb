class Organization < ApplicationRecord
  has_many :drivers, dependent: :destroy
  has_many :riders,  dependent: :destroy
  has_many :location_relationships, dependent: :destroy
  has_many :locations, -> {distinct}, through: :location_relationships
  has_many :rides, dependent: :destroy
  has_many :tokens, through: :riders
  has_many :reasons

  validates :name, :street, :city, :state, :zip, presence: true
  validates :use_tokens, inclusion: { in: [ true, false ] }

end
