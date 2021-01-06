class RideCategory < ApplicationRecord
  belongs_to :organization
  belongs_to :ride, optional: true
end
