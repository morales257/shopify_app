class AddShopAssociationToContacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :contacts, :shop, foreign_key: true 
  end
end
