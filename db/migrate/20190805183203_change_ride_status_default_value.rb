class ChangeRideStatusDefaultValue < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:rides, :status, from: "requested", to: "pending")
  end
end
