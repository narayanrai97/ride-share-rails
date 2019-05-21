class CreateScheduleWindowExceptions < ActiveRecord::Migration[5.2]
  def change
    create_table :schedule_window_exceptions do |t|
      t.belongs_to :schedule_window
      t.boolean :is_canceled
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end
  end
end
