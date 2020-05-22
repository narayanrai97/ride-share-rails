class RideSerializer < ActiveModel::Serializer
  ActiveModelSerializers.config.adapter = :json
  attributes :id, :organization_id, :driver_id, :pick_up_time, :rider, :start_location, :end_location,  :reason, :status, :completed_at, :round_trip, :expected_wait_time,
  :pickup_to_dropoff_distance, :pickup_to_dropoff_time, :default_to_pickup_distance

  def default_to_pickup_distance
    #access driver's default address here. It's one specific address to a driver
    default_location_relationship = scope.current_driver.location_relationships.find_by(default: true)
    if default_location_relationship != nil
      driver_default_location = Location.find(default_location_relationship.location_id)
      geodistance = Geodistance.new(driver_default_location, object.start_location)
      return geodistance.calculate_distance.round(1)
    else
      return nil
    end
  end

  def rider
    rider = Rider.find(object.rider_id)
    {
      first_name: rider.first_name,
      last_name: rider.last_name,
      phone: rider.phone,
      note: rider.notes
    }
  end

end
