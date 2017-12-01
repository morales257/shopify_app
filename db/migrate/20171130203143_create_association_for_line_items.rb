class CreateAssociationForLineItems < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_items, :checkout, index: true, foreign_key: true
  end
end
