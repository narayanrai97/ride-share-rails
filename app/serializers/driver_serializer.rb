class DriverSerializer < ActiveModel::Serializer
  ActiveModelSerializers.config.adapter = :json
  attributes :organization_id, :id, :first_name, :last_name, :phone,
             :email, :radius, :is_active, :application_state
  has_many :vehicles

  def locations

  end

end
