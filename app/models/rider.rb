class Rider < ApplicationRecord

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  # validates :email, presence: true

  belongs_to :organization
  has_many :tokens, dependent: :destroy
  has_many :rides

  devise :database_authenticatable,
            :recoverable, :rememberable, :validatable



  def full_name
    first_name + " " + last_name
  end

  def next_token
    self.tokens.where(is_valid: true).
                where('expires_at >= ?', Time.zone.now).
                where(ride_id: nil).
                order(:expires_at).first
  end

end
