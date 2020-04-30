class Rider < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  belongs_to :organization
  has_many :location_relationships
  has_many   :tokens, dependent: :destroy
  has_many   :rides
  has_many :locations, -> { distinct }, through: :location_relationships

  validates :first_name, :last_name, :phone, :organization, presence: true
  validates :phone, length: { is: 10 }, numericality: true
  validates :password, format: {with: /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,25}$/, multiline: true, message: 'must be at least 8 characters long and include 1 uppercase, 1 number, and 1 special character.'}
  scope :active, -> { where(is_active: true) }
  before_save :lets_cap, only: [:new, :create]


  def lets_cap
    self.first_name = self.first_name.capitalize
    self.last_name =  self.last_name.capitalize
  end

  def full_name
    first_name + " " + last_name
  end

  def valid_tokens
    self.tokens.where(is_valid: true).
                where('expires_at >= ?', Time.zone.now).
                where(ride_id: nil).
                order(:expires_at)
  end

  def next_valid_token
      self.valid_tokens.first
  end

  def valid_tokens_count
    self.valid_tokens.size
  end

end
