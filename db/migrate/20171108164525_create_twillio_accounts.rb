class CreateTwillioAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :twillio_accounts do |t|
      t.string :subaccount_name
      t.integer :phone_number

      t.timestamps
    end
  end
end
