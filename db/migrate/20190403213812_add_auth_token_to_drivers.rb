class AddAuthTokenToDrivers < ActiveRecord::Migration[5.2]
  def change
    add_column :drivers, :auth_token, :string
    add_index :drivers, :auth_token
  end
end
