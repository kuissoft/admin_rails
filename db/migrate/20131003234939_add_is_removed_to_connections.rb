class AddIsRemovedToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :is_removed, :bool, default: false
  end
end
