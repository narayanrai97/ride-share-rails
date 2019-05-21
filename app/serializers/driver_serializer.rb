class DriverSerializer < ActiveModel::Serializer

  attributes :organization_id, :id, :first_name, :last_name, :phone,
             :email, :car_make, :car_model, :car_color, :radius, :is_active

  def locations

  end

end