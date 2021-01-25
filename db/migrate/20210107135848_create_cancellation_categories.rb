class CreateCancellationCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :cancellation_categories do |t|
      t.string :name
      t.text :description
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
