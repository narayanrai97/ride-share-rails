class LocationRelationship < ApplicationRecord

  belongs_to :location, optional: true
  belongs_to :driver, optional: true
  belongs_to :rider, optional: true
  belongs_to :organization, optional: true
end
