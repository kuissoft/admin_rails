class AddResetCountToDeviceControls < ActiveRecord::Migration
  def change
    add_column :device_controls, :reset_count, :integer, default: 0
  end
end
