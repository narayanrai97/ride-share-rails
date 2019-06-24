class RiderSerializer < ActiveModel::Serializer

  attributes :organization_id, :id, :first_name, :last_name, :phone,
             :email
end