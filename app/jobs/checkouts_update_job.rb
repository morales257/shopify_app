class CheckoutsUpdateJob < ActiveJob::Base
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)
    shop.with_shopify_session do
      puts "starting session"
      if webhook[:shipping_address][:phone]
        puts "creating AC"
        checkout =
            {
              checkout_id: webhook[:id],
              puts "id saved"
              phone: webhook[:shipping_address][:phone],
              puts "phone saved"
              first_name: webhook[:shipping_address][:first_name],
              puts "name saved"
              last_name: webhook[:shipping_address][:last_name],
              puts "last name saved"
              email: webhook[:email],
              puts "email saved"
              discount_codes: webhook[:discount_codes][:code]
              puts "codes saved"
            }
        puts "creating new checkout"
        new_checkout = Checkout.where(checkout_id: checkout[:checkout_id]).first_or_create(checkout)
        shop.checkouts << new_checkout
        puts "Saved new checkout" if new_checkout.saved?
      else
        puts "This checkout does not have a phone number"
      end
    end
  end
end
