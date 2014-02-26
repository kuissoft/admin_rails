class AddLanguageToDeviceControls < ActiveRecord::Migration
  def change
    add_column :device_controls, :language, :string, :default => 'en'
  end
end
