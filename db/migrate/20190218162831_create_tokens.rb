class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|

      t.belongs_to :rider
      t.timestamp :created_at
      t.timestamp :expires_at
      t.timestamp :used_at
      t.boolean :is_valid
      t.timestamps
    end
  end
end
