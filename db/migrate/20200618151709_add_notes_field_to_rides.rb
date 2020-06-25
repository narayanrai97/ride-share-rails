class AddNotesFieldToRides < ActiveRecord::Migration[5.2]
  def change
    add_column :rides, :notes, :string
  end
end
