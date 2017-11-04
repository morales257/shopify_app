class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage

  has_many :checkouts, dependent: :destroy
  has_many :orders, dependent: :destroy
end
