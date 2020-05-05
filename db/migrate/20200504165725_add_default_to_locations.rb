class AddDefaultToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :default, :boolean, null: false, default: false
  end
end
