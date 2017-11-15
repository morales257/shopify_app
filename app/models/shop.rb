require './lib/apis/twilio_subaccount.rb'
require 'pry'
class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage

  has_many :checkouts, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :twilio_account, dependent: :destroy

  after_find :set_location
  after_update :create_twilio_subaccount
  after_destroy :delete_twilio_subaccount

  def with_shopify!
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end

  private

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

  def create_twilio_subaccount
    puts "creating Twilio"
    sub_account_name = TwilioSubaccount.new.new_account(self.shopify_domain)
    self.create_twilio_account(subaccount_name: sub_account_name )
    #self.update_attribute(twilio_name, TwilioAccount.new.new_account(self.shop_domain + "Twilio"))
    #self.save
  end

  def delete_twilio_subaccount
    TwilioAccount.new.close_account(self)
    Rails.logger.info "Deleted Twilio Account"
  end

end
