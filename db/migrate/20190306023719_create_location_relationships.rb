class CreateLocationRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :location_relationships do |t|
      t.belongs_to :location
      t.belongs_to :driver
      t.belongs_to :rider
      t.belongs_to :organization
      t.timestamps
    end
  end
end
