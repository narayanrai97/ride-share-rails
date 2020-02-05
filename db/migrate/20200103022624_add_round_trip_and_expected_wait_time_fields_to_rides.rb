class AddRoundTripAndExpectedWaitTimeFieldsToRides < ActiveRecord::Migration[5.2]
  def change
    add_column :rides, :round_trip, :boolean, null: false, default: false
    add_column :rides, :expected_wait_time, :string
  end
end
