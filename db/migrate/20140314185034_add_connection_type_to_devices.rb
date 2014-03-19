class AddConnectionTypeToDevices < ActiveRecord::Migration
  def change
    remove_column :users, :connection_type
    remove_column :users, :is_online
    add_column :devices, :connection_type, :string
    add_column :devices, :online, :boolean, default: false
  end
end
