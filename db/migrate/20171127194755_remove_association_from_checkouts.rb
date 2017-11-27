class RemoveAssociationFromCheckouts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :checkouts, :shop, foreign_key: true, index: true
  end
end
