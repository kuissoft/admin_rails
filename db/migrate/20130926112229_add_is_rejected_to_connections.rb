class AddIsRejectedToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :is_rejected, :boolean, default: false
  end
end
