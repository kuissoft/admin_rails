class AddLastOnlineAtToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_online_at, :datetime
  end
end
