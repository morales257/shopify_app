class AddCountryToShop < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :country, :string
    add_column :shops, :region, :string
  end
end
