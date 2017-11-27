class AddTokenToCheckouts < ActiveRecord::Migration[5.1]
  def change
    add_column :checkouts, :token, :string
  end
end
