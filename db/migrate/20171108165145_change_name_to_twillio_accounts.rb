class ChangeNameToTwillioAccounts < ActiveRecord::Migration[5.1]
  def change
    rename_table :twillio_accounts, :twilio_accounts
  end
end
