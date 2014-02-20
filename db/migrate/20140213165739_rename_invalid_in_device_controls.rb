class RenameInvalidInDeviceControls < ActiveRecord::Migration
  def change
    rename_column :device_controls, :invalid, :invalid_count
  end
end
