class OrdersCreateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    shop.with_shopify_session do
      checkout = Checkout.find_by(checkout_id: webhook[:checkout_id])
      if !checkout.nil?
        Rails.logger.info "Found a checkout with this ID"
        checkout.destroy
        Rails.logger.info "Removed Abandoned Checkout from DB"
      else
        Rails.logger.info "No checkout exists with this ID"
      end
    end
  end
end
