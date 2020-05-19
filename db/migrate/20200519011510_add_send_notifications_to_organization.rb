class AddSendNotificationsToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :send_notifications, :boolean
  end
end
