class AddNotesFieldToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :notes, :string
  end
end
