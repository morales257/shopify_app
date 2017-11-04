class Checkout < ApplicationRecord
  belongs_to :shop, optional: true
  validates :phone, presence: true
end
