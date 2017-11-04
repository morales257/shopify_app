require 'pry'
class CheckoutsUpdateJob < ActiveJob::Base

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    shop.with_shopify_session do
      Rails.logger.info "starting session"

      if webhook[:shipping_address][:phone] || webhook[:phone]
        Rails.logger.info "creating AC"
        checkout = {
                      checkout_id: webhook[:id],
                      phone: webhook[:shipping_address][:phone] || webhook[:phone],
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
