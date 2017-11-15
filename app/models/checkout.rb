require './lib/apis/twilio_subaccount.rb'
class Checkout < ApplicationRecord
  belongs_to :shop, optional: true
  validates :phone, presence: true

  after_create :send_text

  private

  def send_text
    TwilioSubaccount.new.sms(self)
    #code
  end
end
