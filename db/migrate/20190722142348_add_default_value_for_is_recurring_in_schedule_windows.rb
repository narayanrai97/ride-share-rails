class AddDefaultValueForIsRecurringInScheduleWindows < ActiveRecord::Migration[5.2]
  def up
    change_table :schedule_windows do |t|
      t.change :is_recurring, :boolean, default: false
    end
  end

  def down
    change_table :schedule_windows do |t|
      t.change :is_recurring, :boolean, default: false, null: false
    end
  end
end
