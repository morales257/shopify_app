class Order < ApplicationRecord
  belongs_to :shop, optional: true
end
