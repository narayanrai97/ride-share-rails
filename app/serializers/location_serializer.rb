class LocationSerializer < ActiveModel::Serializer

  attributes :id, :street, :city, :state, :zip
end