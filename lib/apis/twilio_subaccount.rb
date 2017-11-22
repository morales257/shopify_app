require 'twilio-ruby'
require 'pry'

#this is all the code that accesses the API
class TwilioSubaccount

  def open_api_connection
    account_sid = ENV['ACCOUNT_SID']
    auth_token = ENV['AUTH_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def open_test_api_connection
    account_sid =
    auth_token =
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def open_subapi_connection(sid, auth_token)
    @client = Twilio::REST::Client.new(sid, auth_token)
  end

  def subaccount_exists?(shop)
    open_api_connection
    shop_account = @client.api.accounts.list(friendly_name: shop + "twilio", status: 'active').first
    if !shop_account.nil?
      return shop_account.friendly_name
    else
      return nil
    end
  end

  def new_account(shop)
    open_api_connection
    @account = @client.api.accounts.create(friendly_name: shop + "twilio")
    return @account.friendly_name
  end

  def get_subaccount_credentials(sub_name)
    open_api_connection
    @subaccount = @client.api.accounts.list(friendly_name: sub_name).first
    @sid, @auth_token = @subaccount.sid, @subaccount.auth_token
  end

  def assign_phonenumber_to_sub(shop)
    connection = open_api_connection
    avail_number = connection.incoming_phone_numbers.list(friendly_name:
      "#{shop.region}, #{shop.country}").first
    unless avail_number
      purchase_phonenumber(shop)
      assign_phonenumber_to_sub(shop)
    else
      avail_number.update(account_sid: shop.twilio_account.sid)
      puts "#{avail_number.phone_number} assigned to #{shop.shopify_domain} Twilio Account."
      shop.twilio_account.update_attributes(phone_number: avail_number.phone_number )
      puts "assigned phone number"
    end
  end

  def purchase_phonenumber(shop)
    open_api_connection
    @numbers = @client.api.available_phone_numbers("#{shop.country}").local.list(in_region: "#{shop.region}")
    @number = @numbers[0].phone_number
    @client.incoming_phone_numbers.create(phone_number: @number, friendly_name: "#{shop.region}, #{shop.country}")
    puts "This phone number #{@number} has been added to Twilio"
  end

  def search_for_number(shop)
    open_api_connection
    @numbers = @client.api.available_phone_numbers("#{shop.country}").local.list(in_region: "#{shop.region}")
    @number = @numbers[0].phone_number
  end

  def return_phone_to_master(sid, auth_token)
    open_subapi_connection(sid, auth_token)
    @client.incoming_phone_numbers.list.each do |number|
      number.update(account_sid: ENV['ACCOUNT_SID'])
      puts "#{number.phone_number} moved from #{number.account_sid}"
    end
  end

  def close_account(shop)
    open_api_connection
    @account = @client.api.accounts(shop).fetch
    @account.update(status: 'closed')

    puts @account.status
  end

  def sms(person)
    open_api_connection
    phone_number = "+1" + person.phone.to_s
    @message = @client.messages.create(
      from: ,
      to: "#{phone_number}",
      body: "Hey #{person.first_name}, you left without buying anything. WTF??"
      )

      Rails.logger.info @message.status
    #code
  end
end
