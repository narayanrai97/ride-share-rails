class AddBackgroundCheckToDrivers < ActiveRecord::Migration[5.2]
  def change
    add_column :drivers, :background_check, :boolean, null: false, default: false
  end
end
