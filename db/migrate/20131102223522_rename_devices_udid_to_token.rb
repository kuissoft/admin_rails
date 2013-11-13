class RenameDevicesUdidToToken < ActiveRecord::Migration
  def change
    rename_column :devices, :udid, :token
  end
end
