class CreateRideCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :ride_categories do |t|
      t.string :name
      t.text :description
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
