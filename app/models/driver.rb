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
  
  def events(start_date, end_date)
    list = []
    schedule_windows.each do |e|
      if e.is_recurring
        list += recurring_event(e)
      else
        list += nonrecurring_event(e)
      end
    end
    list.sort_by{|i| i[:start_time]}.reverse
  end
  
  def nonrecurring_event(window)
    {
      "eventId": events.id, 
      "startTime": events.start_time, 
      "endTime": events.end_time, 
      "isRecurring": events.is_recurring, 
      "location": location
    }
  end
  
  def recurring_event(start)
    if start.dow == day_of_week
      elsif first ==start.dow < day_of_week
      first = start + (day_of_week - start.dow).day
    else
      first = start + (7 - (start.dow - day_of_week)).days
    end
  end
end
