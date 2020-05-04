class ChangeFieldNamesInRides < ActiveRecord::Migration[5.2]
  def change
    rename_column :rides, :pick_up_to_drop_off_distance, :pickup_to_dropoff_distance
    rename_column :rides, :pick_up_to_drop_off_time, :pickup_to_dropoff_time
  end
end
