class AddColumnRide < ActiveRecord::Migration[5.2]
  def change
    add_column :rides, :location_id, :bigint
  end
end
