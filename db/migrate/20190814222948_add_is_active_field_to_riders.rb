class AddIsActiveFieldToRiders < ActiveRecord::Migration[5.2]
  def change
    add_column :riders, :is_active, :boolean, null: false, default: true
  end
end
