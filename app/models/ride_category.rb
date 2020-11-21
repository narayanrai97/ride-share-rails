class RideCategory < ApplicationRecord
  belongs_to :organization
  has_many :reasons
  validates :name, presence: true
end
