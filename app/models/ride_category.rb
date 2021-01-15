class RideCategory < ApplicationRecord
  before_save :titleize_name
  belongs_to :organization
  belongs_to :ride, optional: true


  # private
    def titleize_name
      self.name = self.name.titleize
    end
end
