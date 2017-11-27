class Contact < ApplicationRecord
  belongs_to :shop
  validates :phone, presence: true
  validates :phone_number, uniqueness: true
end
