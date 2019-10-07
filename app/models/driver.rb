class Driver < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, length: { is: 12 }
  validates_format_of :phone, :with => /\(?[0-9]{3}\)?-[0-9]{3}-[0-9]{4}/,
                              :message => "number must be in xxx-xxx-xxxx format."
  validates :email, presence: true

  belongs_to :organization
  has_many :rides
  has_many :schedule_windows
  has_many :vehicles ,dependent: :destroy


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  scope :active, -> { where(is_active: true) }
  scope :pending, -> { where(application_state: "pending") }
  scope :accepted, -> { where(application_state: "accepted") }
  scope :rejected, -> { where(application_state: "rejected") }


  def full_name
    "#{first_name} #{last_name}"
  end

  def generate_auth_token
    token = SecureRandom.hex
    self.update_columns(auth_token: token, token_created_at: Time.zone.now)
    token
  end

  def invalidate_auth_token
    self.update_columns(auth_token: nil, token_created_at: nil)
  end

  def events(query_start_date, query_end_date)
    list = []
    schedule_windows.each do |window|
      list += window.events(query_start_date, query_end_date)
    end
    list.sort_by{|i| i[:start_time]}.reverse
  end

  def ride_cancel_alert

  end
end
