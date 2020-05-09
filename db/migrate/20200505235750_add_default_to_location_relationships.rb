class AddDefaultToLocationRelationships < ActiveRecord::Migration[5.2]
  def change
    add_column :location_relationships, :default, :boolean, null: false
  end
end
