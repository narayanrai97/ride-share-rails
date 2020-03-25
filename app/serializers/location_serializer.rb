class LocationSerializer < ActiveModel::Serializer
  ActiveModelSerializers.config.adapter = :json
  attributes :id, :street, :city, :state, :zip, :notes

  has_many :location_relationships
end
