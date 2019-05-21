class AddTokenCreatedAtToDrivers < ActiveRecord::Migration[5.2]
  def change
    add_column :drivers, :token_created_at, :datetime
    remove_index :drivers, :auth_token
    add_index :drivers, [:auth_token, :token_created_at]
  end
end
