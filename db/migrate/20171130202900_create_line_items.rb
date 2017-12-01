class CreateLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :line_items do |t|
      t.string :product
      t.string :price

      t.timestamps
    end
  end
end
