class CreateRecurringPatterns < ActiveRecord::Migration[5.2]
  def change
    create_table :recurring_patterns do |t|
      t.belongs_to :schedule_window
      t.integer :separation_count
      t.integer :day_of_week
      t.integer :week_of_month
      t.integer :month_of_year
      t.string :type_of_repeating
      t.timestamps
    end
  end
end
