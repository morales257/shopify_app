require './lib/apis/twilio_subaccount.rb'
require 'pry'
class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage

  has_many :checkouts, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :twilio_account, dependent: :destroy

  after_find :set_location
  after_update :setup_twilio_subaccount
  after_destroy :delete_twilio_subaccount

  def with_shopify!
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end

  private
  #adds Store location to DB for better phone number matching
  def set_location
    if self.country.nil? || self.region.nil?
      self.with_shopify!
      shop = ShopifyAPI::Shop.current
      Rails.logger.info "Found shop"
      self.country = shop.country_code
      self.region = shop.province_code
      self.save!
      Rails.logger.info "Shop location saved"
    end
  end

  #creates a Twilio Account for this specific store
  def find_twilio_subaccount
    twilio = TwilioSubaccount.new
    #account_exists = twilio.subaccount_exists?(self.shopify_domain)
    #if !account_exists.nil?
      #assign_credentials_to_sub
      #add_phone_number
    #else
      create_twilio_subaccount
      #assign_credentials_to_sub
      #add_phone_number
    #end
  end

  #different variation of above
  def setup_twilio_subaccount
    create_twilio_subaccount
    add_phone_number
  end

  #creates Twilio Account
  def create_twilio_subaccount
    twilio = TwilioSubaccount.new
    puts "Creating Twilio Account"
    sub_account_name = twilio.new_account(self.shopify_domain)
    self.create_twilio_account(subaccount_name: sub_account_name)
  end

  #Assigns Twilio Credentials to Twilio Account - moved
  def assign_credentials_to_sub
    twilio = TwilioSubaccount.new
    friendly_name = self.twilio_account.subaccount_name
     sid, auth_token = twilio.get_subaccount_credentials(friendly_name)
     unless self.twilio_account.sid == sid
       puts "assigning new credentials"
       self.twilio_account.auth_token = auth_token
       self.twilio_account.sid = sid
       puts "credentials assigned to shop twilio account #{sid}"
     end

  end

  def add_phone_number
    TwilioSubaccount.new.assign_phonenumber_to_sub(self)
  end

  def send_sms(contact)
    TwilioSubaccount.new.sms(contact)
  end

  def delete_twilio_subaccount
    TwilioSubaccount.new.close_account(self)
    Rails.logger.info "Closed Twilio Account"
  end

end
