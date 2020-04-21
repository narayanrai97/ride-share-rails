class DriverSerializer < ActiveModel::Serializer
  ActiveModelSerializers.config.adapter = :json
  attributes :id, :email, :first_name, :last_name, :organization_id, :phone,
             :email, :radius, :is_active, :application_state, :admin_sign_up
  has_many :vehicles

  def locations

  end

end
