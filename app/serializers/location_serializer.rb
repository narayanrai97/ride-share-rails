class LocationSerializer < ActiveModel::Serializer
  ActiveModelSerializers.config.adapter = :json
  attributes :id, :street, :city, :state, :zip, :notes, :default

  has_many :location_relationships
end
