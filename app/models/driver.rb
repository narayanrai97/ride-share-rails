class Driver < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, length: { is: 10 }, numericality: true
  validates :email, presence: true
  validate :image_type

  belongs_to :organization
  has_many :location_relationships
  has_many :rides
  has_many :schedule_windows
  has_many :vehicles ,dependent: :destroy
  has_many :locations, -> { distinct }, through: :location_relationships

   has_one_attached :image
   # validates :image, attached: true, content_type: 'image/png',
   #                                   dimension: { width: 200, height: 200 }
   # validates_attachment_content_type :image, content_type:  ["image/jpg", "image/jpeg", "image/png"]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  scope :active, -> { where(is_active: true) }
  scope :pending, -> { where(application_state: "pending") }
  scope :accepted, -> { where(application_state: "accepted") }
  scope :rejected, -> { where(application_state: "rejected") }
  before_save :lets_cap, only: [:new, :create]
  before_save :downcase_email



  def thumbnail
    return self.image.variant(resize: '300x300>').processed
  end

  def image_type
    if (image.attached? && !image.content_type.in?(['image/jpg','image/png']))
      errors.add(:image, "needs to be JPEG or PNG")
    end
  end

  # Converts email to all lower-case.
  def downcase_email
    email.downcase!
  end

  def lets_cap
     self.first_name = self.first_name.capitalize
     self.last_name = self.last_name.capitalize
  end
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
