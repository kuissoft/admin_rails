class AddTokenToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :token, :string
  end
end
