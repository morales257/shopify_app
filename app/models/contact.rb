class Contact < ApplicationRecord
  belongs_to :shop
  has_many :checkouts
  validates :phone_number, presence: true
  validates :phone_number, uniqueness: true
end
