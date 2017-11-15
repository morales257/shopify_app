class AddShopAssociationToTwilioAccount < ActiveRecord::Migration[5.1]
  def change
    add_reference :twilio_accounts, :shop, foreign_key: true
  end
end
