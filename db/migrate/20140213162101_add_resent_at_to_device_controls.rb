class AddResentAtToDeviceControls < ActiveRecord::Migration
  def change
    add_column :device_controls, :resent_at, :datetime
  end
end
