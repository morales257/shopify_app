class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage

  has_many :checkouts, dependent: :destroy
end
