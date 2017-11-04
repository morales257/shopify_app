class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :order_id, limit: 8
      t.integer :checkout_id, limit: 8
      t.string :name
      t.integer :shop_id, foreign_key: true

      t.timestamps
    end
  end
end
