class CreateScheduleWindows < ActiveRecord::Migration[5.2]
  def change
    create_table :schedule_windows do |t|
      t.belongs_to :driver
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :start_time
      t.datetime :end_time
      t.belongs_to :location
      t.boolean :is_recurring

    end
  end
end
