class CreateCheckouts < ActiveRecord::Migration[5.0]
  def change
    create_table :checkouts do |t|
      t.integer :checkout_id, null: false
      t.string :first_name
      t.string :last_name
      t.string :phone, null: false
      t.string :email
      t.text :discount_codes, array: true, default: []
      t.text :order_items, array: true, default: []

      t.timestamps
    end

    add_index :checkouts, :checkout_id, unique: true
  end
end
