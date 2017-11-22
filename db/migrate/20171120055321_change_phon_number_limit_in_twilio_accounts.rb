class ChangePhonNumberLimitInTwilioAccounts < ActiveRecord::Migration[5.1]
  def change
    change_column :twilio_accounts, :phone_number, :integer, limit: 8
  end
end
