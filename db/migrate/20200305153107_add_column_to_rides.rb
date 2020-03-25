class AddColumnToRides < ActiveRecord::Migration[5.2]
  def change
    add_column :rides, :outbound, :integer
    add_column :rides, :return, :integer
  end
end
