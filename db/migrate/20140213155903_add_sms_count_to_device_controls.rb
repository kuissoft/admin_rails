class AddSmsCountToDeviceControls < ActiveRecord::Migration
  def change
    add_column :device_controls, :sms_count, :integer, default: 0
  end
end
