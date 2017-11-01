class Checkout < ApplicationRecord
  belongs_to :shop, optional: true
end
