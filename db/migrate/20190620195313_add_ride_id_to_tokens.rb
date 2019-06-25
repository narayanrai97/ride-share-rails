class AddRideIdToTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :ride_id, :integer
  end
end
