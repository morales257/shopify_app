require 'pry'
class CheckoutsUpdateJob < ActiveJob::Base

  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    shop.with_shopify_session do
      Rails.logger.info "starting session"
      #binding.pry
      if !webhook[:shipping_address][:phone].blank? || webhook[:phone]
        #start a background job to listen for an order in 5 minutes from now
        #if no order, create abandoned checkout
        checkout_id = webhook[:id]
        checkout_created_at = webhook[:created_at]
        checkout_token = webhook[:token]
        DetermineAbandonementWorker.perform_in(1.minute,shop.shopify_domain,
          checkout_id, checkout_created_at, checkout_token)
      #   Rails.logger.info "creating AC"
      #   checkout = {
      #                 checkout_id: webhook[:id],
      #                 phone: webhook[:shipping_address][:phone] || webhook[:phone],
      #                 first_name: webhook[:shipping_address][:first_name],
      #                 last_name: webhook[:shipping_address][:last_name],
      #                 email: webhook[:email],
      #                 discount_codes: webhook[:discount_codes].map { |discount_code| discount_code[:code]  }
      #               }
      #   if webhook[:billing_address]
      #     Rails.logger.info "This ID is already in the database"
      #   else
      #       Rails.logger.info "creating new checkout"
      #       new_checkout = Checkout.where(checkout_id: checkout[:checkout_id]).first_or_create!(checkout)
      #       shop.checkouts << new_checkout
      #       Rails.logger.info "Saved new checkout"
      #   end
      # else
      #   Rails.logger.info "This checkout does not have a phone number"
       end
    end
  end
end
