class OrganizationSerializer < ActiveModel::Serializer
  ActiveModel::Serializer.config.adapter = :json

  attributes :id, :name, :street, :city, :state, :zip




end
