require 'pry'
class CheckoutsUpdateJob < ActiveJob::Base

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    #binding.pry
    #File.write("shop_domain#{Time.now.to_f}", Marshal.dump(shop_domain)) if shop_domain.present?
    #File.write("webhook.#{Time.now.to_f}", Marshal.dump(webhook)) if webhook.present?
    shop.with_shopify_session do
      Rails.logger.info "starting session"

      if webhook[:shipping_address][:phone]
        #File.write('webhook', Marshal.dump(webhook))
        Rails.logger.info "creating AC"
        Rails.logger.info webhook[:id]
        Rails.logger.info webhook[:shipping_address][:phone]
        Rails.logger.info webhook[:shipping_address][:first_name]
        Rails.logger.info webhook[:shipping_address][:last_name]
        Rails.logger.info webhook[:email]
        Rails.logger.info webhook[:discount_codes].map { |discount_code| discount_code[:code]  }
        checkout = {
                      checkout_id: webhook[:id],
                      phone: webhook[:shipping_address][:phone],
                      first_name: webhook[:shipping_address][:first_name],
                      last_name: webhook[:shipping_address][:last_name],
                      email: webhook[:email],
                      discount_codes: webhook[:discount_codes].map { |discount_code| discount_code[:code]  }
                    }
        Rails.logger.info "creating new checkout"
        new_checkout = Checkout.where(checkout_id: checkout[:checkout_id]).first_or_create!(checkout)
        shop.checkouts << new_checkout
        Rails.logger.info "Saved new checkout"
      else
        Rails.logger.info "This checkout does not have a phone number"
      end
    end
  end
end
