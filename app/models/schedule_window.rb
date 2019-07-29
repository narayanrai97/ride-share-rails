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
  
  def events(query_start_date, query_end_date)
    if is_recurring
      recurring_event(query_start_date, query_end_date)
    else
      nonrecurring_event(query_start_date, query_end_date)
    end
  end
  
  def nonrecurring_event(query_start_date, query_end_date)
    if query_start_date <= start_time && end_time < query_end_date 
      [{
        eventId: id, 
        startTime: start_time, 
        endTime: end_time, 
        isRecurring: false, 
        location: location
      }]
    else
      []
    end
  end
  
  def recurring_event(query_start_date, query_end_date)
    case recurring_pattern.type_of_repeating
    when 'weekly'
      recurring_weekly(query_start_date, query_end_date)
    else
      return []
    end
  end
  
  def recurring_weekly(query_start_date, query_end_date)
    dow = recurring_pattern.day_of_week
    start_dow = query_start_date.wday
    
    if start_dow <= dow
      current = query_start_date + (dow - start_dow).days
    else
      current = query_start_date + (7 - (start_dow - dow)).days
    end
    
    results = []
    while current <= query_end_date && current <= end_date
      results.unshift({
        eventId: id, 
        startTime: current.strftime('%Y-%m-%d') + " " + start_time.strftime('%H:%M'), 
        endTime: current.strftime('%Y-%m-%d') + " " + end_time.strftime('%H:%M'), 
        isRecurring: true, 
        location: location
      })
      current = current + (7 * (recurring_pattern.separation_count + 1)).days
    end
    
    return results
  end

end
