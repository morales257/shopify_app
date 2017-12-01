class RemoveNullFromCheckouts < ActiveRecord::Migration[5.1]
  def change
    change_column_null :checkouts, :phone, true 
  end
end
