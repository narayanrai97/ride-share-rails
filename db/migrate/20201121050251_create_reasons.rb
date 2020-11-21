class CreateReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :reasons do |t|
      t.string :details
      t.references :ride, foreign_key: true
      t.references :ride_category, foreign_key: true

      t.timestamps
    end
  end
end
