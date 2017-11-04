class Checkout < ApplicationRecord
  belongs_to :shop, optional: true
  validate :phone, presence: true
end
