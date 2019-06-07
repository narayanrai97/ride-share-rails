class DriverSerializer < ActiveModel::Serializer

  attributes :organization_id, :id, :first_name, :last_name, :phone,
             :email, :radius, :is_active

  def locations

  end

end
