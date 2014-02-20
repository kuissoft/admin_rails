class AddConnectionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_online, :boolean, default: false
    add_column :users, :connection_type, :string
  end
end
