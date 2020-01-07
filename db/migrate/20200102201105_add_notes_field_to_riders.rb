class AddNotesFieldToRiders < ActiveRecord::Migration[5.2]
  def change
    add_column :riders, :notes, :string
  end
end
