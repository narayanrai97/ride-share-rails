class Driver < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  validates :email, presence: true

  belongs_to :organization
  has_many :rides
  has_many :schedule_windows
  has_many :vehicles ,dependent: :destroy


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def generate_auth_token
    token = SecureRandom.hex
    self.update_columns(auth_token: token, token_created_at: Time.zone.now)
    token
  end

  def invalidate_auth_token
    self.update_columns(auth_token: nil, token_created_at: nil)
  end
  
  def events(query_start_date, query_end_date)
    query_start_date = Date.parse(query_start_date)
    query_end_date = Date.parse(query_end_date)
    list = []
    schedule_windows.each do |e|
      if e.is_recurring
        list += recurring_event(e, query_start_date, query_end_date)
      else
        list << nonrecurring_event(e)
      end
    end
    list.sort_by{|i| i[:start_time]}.reverse
  end
  
  # TODO add query dates and only return if window is inside dates
  def nonrecurring_event(window)
    {
      eventId: window.id, 
      startTime: window.start_time, 
      endTime: events.end_time, 
      isRecurring: false, 
      location: window.location
    }
  end
  
  def recurring_event(window, query_start_date, query_end_date)
    case window.recurring_pattern.type_of_repeating
    when 'weekly'
      recurring_weekly(window, query_start_date, query_end_date)
    else
      return []
    end
  end
  
  def recurring_weekly(window, query_start_date, query_end_date)
    dow = window.recurring_pattern.day_of_week
    start_dow = query_start_date.wday
    
    if start_dow <= dow
      current = query_start_date + (dow - start_dow).days
    else
      current = query_start_date + (7 - (start_dow - dow)).days
    end
    
    results = []
    while current <= query_end_date && current <= window.end_date
      results.unshift({
        eventId: window.id, 
        startTime: current.strftime('%Y-%m-%d') + " " + window.start_time.strftime('%H:%M'), 
        endTime: current.strftime('%Y-%m-%d') + " " + window.end_time.strftime('%H:%M'), 
        isRecurring: true, 
        location: window.location
      })
      current = current + (7 * (window.recurring_pattern.separation_count + 1)).days
    end
    
    return results
  end
  
  #TODO write code for non recurring pattern 
  # def recurring_month(window, query_start_date, query_end_date)
  #   dow = window.recurring_pattern.day_of_week
  #   start_dow = query_start_date.dow 
  #   if start_dow == dow
  #     first = query_start_date
  #   elsif start_dow < dow
  #     first = query_start_date + (dow - start_dow).days
  #   else
  #     first = query_start_date + (30 - (start_dow - dow)).days
  #       end
  #  end
end

