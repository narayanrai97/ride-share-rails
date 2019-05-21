class CreateRides < ActiveRecord::Migration[5.2]
  def change
    create_table :rides do |t|
      t.belongs_to :organization
      t.belongs_to :rider
      t.belongs_to :driver
      t.timestamp :pick_up_time

      t.references :start_location
      t.references :end_location


      t.text :reason
      t.string :status, default: 'requested'

      t.timestamps
    end
  end
end
