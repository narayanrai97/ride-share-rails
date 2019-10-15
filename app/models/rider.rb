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

  scope :active, -> { where(is_active: true) }

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
