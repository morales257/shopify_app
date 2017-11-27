class AddAssociationToContacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :contacts, :checkouts, index: true, foreign_key: true
  end
end
