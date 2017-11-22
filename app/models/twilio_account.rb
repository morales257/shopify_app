require './lib/apis/twilio_subaccount.rb'
class TwilioAccount < ApplicationRecord
  belongs_to :shop

  after_create :set_credentials
  before_destroy :release_phone_number

  private

  def set_credentials
    @subaccount = self
    twilio = TwilioSubaccount.new
    friendly_name = @subaccount.subaccount_name
     sid, auth_token = twilio.get_subaccount_credentials(friendly_name)
     unless @subaccount.sid == sid
       puts "assigning new credentials"
       @subaccount.update_attributes(sid: sid, auth_token: auth_token)
       puts "credentials assigned to shop twilio account #{sid}"
     end
  end

  def release_phone_number
    twilio = TwilioSubaccount.new
    twilio.return_phone_to_master(self.sid, self.auth_token)
  end
end
