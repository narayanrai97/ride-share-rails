class Token < ApplicationRecord
  belongs_to :ride, optional: true
  belongs_to :rider
  before_create :set_expiration_date

  def set_expiration_date
    self.expires_at = Time.now + 30.days
  end
end
