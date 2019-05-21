class Organization < ApplicationRecord
  has_many :drivers, dependent: :destroy
  has_many :riders, dependent: :destroy
  has_many :rides, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

end
