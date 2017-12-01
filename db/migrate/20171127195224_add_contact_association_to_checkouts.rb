class AddContactAssociationToCheckouts < ActiveRecord::Migration[5.1]
  def change
    add_reference :checkouts, :contact, index: true, foreign_key: true
  end
end
