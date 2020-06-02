class LocationSerializer < ActiveModel::Serializer
  ActiveModelSerializers.config.adapter = :json
  attributes :id, :street, :city, :state, :zip, :notes, :default_location

  def default_location
    LocationRelationship.find_by(location_id: object.id, driver_id: scope.current_driver).default
  end
end
