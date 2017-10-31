class CheckoutsUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    shop.with_shopify_session do
      if webhook[:shipping_address][:phone]
        checkout =
            {
              checkout_id: webhook[:id],
              phone: webhook[:shipping_address][:phone],
              first_name: webhook[:shipping_address][:first_name],
              last_name: webhook[:shipping_address][:last_name],
              email: webhook[:email],
              discount_codes: webhook[:discount_codes][:code]
            }
        checkout = Checkout.where(checkout_id: checkout[:checkout_id]).first_or_create(checkout)
        shop.checkouts << checkout
      else
        puts "This checkout does not have a phone number"
      end
    end
  end
end
