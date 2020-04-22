class AddAdminSignUpFieldToDrivers < ActiveRecord::Migration[5.2]
  def change
    add_column :drivers, :admin_sign_up, :boolean, default: true
  end
end
