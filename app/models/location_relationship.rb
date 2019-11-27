class LocationRelationship < ApplicationRecord

  belongs_to :location, optional: true
  belongs_to :driver, optional: true
  belongs_to :rider, optional: true
  belongs_to :organization, optional: true
  
  def save_or_touch
    lr = LocationRelationship.find_by(location_id: self.location_id, driver_id: self.driver_id, rider_id: self.rider_id,
         organization_id: self.organization_id)
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
end
