class ChangePickUpToDropOffDistanceToBeFloatInRide < ActiveRecord::Migration[5.2]
  def change
    change_column :rides, :pick_up_to_drop_off_distance, :float
  end
end
