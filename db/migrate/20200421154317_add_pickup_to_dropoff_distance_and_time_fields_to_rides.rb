class AddPickupToDropoffDistanceAndTimeFieldsToRides < ActiveRecord::Migration[5.2]
  def change
    add_column :rides, :pick_up_to_drop_off_distance, :integer
    add_column :rides, :pick_up_to_drop_off_time, :datetime
  end
end
