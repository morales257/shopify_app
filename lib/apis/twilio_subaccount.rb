require 'twilio-ruby'
require 'pry'
class TwilioSubaccount
  #account_sid = ENV['ACCOUNT_SID']
  #auth_token = ENV['AUTH_TOKEN']

  def open_api_connection
    account_sid = 'ACff7c64b67edb96dae3df574a32a9857a'
    auth_token = '71dc5288330136cdf3782d1d3d926bbb'
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def new_account(shop)
    open_api_connection
    account = @client.api.accounts.create(friendly_name: shop + "twilio")
    return account.friendly_name
  end

  def close_account(shop)
    open_api_connection
    @account = @client.api.accounts(friendly_name: shop.twilio_account.friendly_name).fetch
    @account.update(status: 'closed')

    puts @account.date_created
  end

  def sms(person)
    open_api_connection
    phone_number = "+1" + person.phone.to_s
    @message = @client.messages.create(
      from: '+12893010907',
      to: "#{phone_number}",
      body: "Hey #{person.first_name}, you left without buying anything. WTF??"
      )

      Rails.logger.info @message.status
    #code
  end
end
