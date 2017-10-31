class AddAssociationToCheckouts < ActiveRecord::Migration[5.0]
  def change
    add_reference :checkouts, :shop, index: true, foreign_key: true
  end
end
