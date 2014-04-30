class ChangeTokenToApnsTokenInDevices < ActiveRecord::Migration
  def change
    rename_column :devices, :token, :apns_token
  end
end
