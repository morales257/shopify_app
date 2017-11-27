require 'pry'
class DetermineAbandonementWorker
  include Sidekiq::Worker

  def perform(shopdomain, created_at, checkout_token, checkout_id)
    puts "checkout #{checkout_token} was created at #{created_at}"
    shop = Shop.find_by(shopify_domain: shopdomain)
    shop.with_shopify!
    checkout = ShopifyAPI::Checkout.find(checkout_token)
    unless checkout.order
      Rails.logger.info "creating AC"
      abandoned_checkout = {
                  checkout_id: checkout_id,
                   token: checkout_token
                   #discount_codes: checkout.discount_codes.map { |discount_code| discount_code[:code]  }
                    }
      customer = {
        phone: checkout.shipping_address.phone || checkout.phone || checkout.customer.phone,
        first_name: checkout.shipping_address.first_name,
        last_name: checkout.shipping_address.last_name,
         email: checkout.email,
      }
      unless shop.contacts.where(phone_number: customer[:phone]).exists?
        shop.contacts.create!(customer)
        Rails.logger.info "#{customer[:first_name]} added to your Contacts."
      end

      contact = Contact.find_by(phone_number: customer[:phone])
      new_checkout = Checkout.where(checkout_id: checkout.id).first_or_create!(abandoned_checkout)
      contact.checkouts << new_checkout
      Rails.logger.info "Saved new checkout"
    end
    #orders = ShopifyAPI::Order.find(:all, :params => { :created_at_min => created_at, :fields => "checkout_token"})
#     @order = ""
#
#     if !orders.blank?
#       orders.each do |order|
#         unless order.checkout_id == checkout_ids
#           @order = true
#         else
#           @order = false
#         end
#       end
#     else
#       @order = "There were zero orders during this time"
#     end
#     puts "#{@order}"
   end
 end
