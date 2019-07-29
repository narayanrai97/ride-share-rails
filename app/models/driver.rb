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
    schedule_windows.each do |window|
      list += window.events(query_start_date, query_end_date)
    end
    list.sort_by{|i| i[:start_time]}.reverse
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

