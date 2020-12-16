class CreateCancellationReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :cancellation_reasons do |t|
      t.string :name, null: false
      t.text :description
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
