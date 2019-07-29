class ScheduleWindow < ApplicationRecord
  belongs_to :driver
  belongs_to :location

  has_one :recurring_pattern
 
  # after_create :create_recurring_pattern
  
  # def create_recurring_pattern
  #   if is_recurring
  #     RecurringPattern.create(schedule_window_id: id, day_of_week: start_time.wday)
  #   end
  # end

end
