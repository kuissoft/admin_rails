class AddTimestampsToDeviceControls < ActiveRecord::Migration
  def change
    add_column :device_controls, :created_at, :datetime
    add_column :device_controls, :updated_at, :datetime
  end
end
