class CheckoutsUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    shop.with_shopify_session do
      puts "starting session"
      if webhook[:shipping_address][:phone]
        #puts "creating AC"
        #checkout = {
        #              checkout_id: webhook[:id],
        #              phone: webhook[:shipping_address][:phone],
        #              first_name: webhook[:shipping_address][:first_name],
        #              last_name: webhook[:shipping_address][:last_name],
        #              email: webhook[:email],
        #              discount_codes: webhook[:discount_codes][:code]
        #            }
        puts "creating new checkout"
        new_checkout = Checkout.where(checkout_id: webhook[:id]).first_or_create(
        phone: webhook[:shipping_address][:phone], first_name: webhook[:shipping_address][:first_name],
        last_name: webhook[:shipping_address][:last_name], email: webhook[:email], discount_codes: webhook[:discount_codes][:code])
        shop.checkouts << new_checkout
        puts "Saved new checkout"
      else
        puts "This checkout does not have a phone number"
      end
    end
  end
end
