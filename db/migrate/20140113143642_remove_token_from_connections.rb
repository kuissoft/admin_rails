class RemoveTokenFromConnections < ActiveRecord::Migration
  def change
    remove_column :connections, :token
  end
end
