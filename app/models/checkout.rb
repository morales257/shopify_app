require './lib/apis/twilio_subaccount.rb'
class Checkout < ApplicationRecord
  belongs_to :shop, optional: true


  #after_create :send_text
  #after_create 1. find conversation

  private



  def send_text
    @chekout = self
    @shop = Shop.find_by(id: @checkout.shop_id)
    @shop.send_sms(@checkout)
    #code
  end


end
