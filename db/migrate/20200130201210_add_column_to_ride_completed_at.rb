class AddColumnToRideCompletedAt < ActiveRecord::Migration[5.2]
  def change
    add_column :rides, :completed_at, :Date
  end
end
