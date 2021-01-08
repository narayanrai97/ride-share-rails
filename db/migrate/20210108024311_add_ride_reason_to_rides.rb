class AddRideReasonToRides < ActiveRecord::Migration[5.2]
  def change
    add_column :rides, :ride_reason, :string
  end
end
