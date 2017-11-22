class AddCredentialsToTwilioAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :twilio_accounts, :sid, :string
    add_column :twilio_accounts, :auth_token, :string
  end
end
