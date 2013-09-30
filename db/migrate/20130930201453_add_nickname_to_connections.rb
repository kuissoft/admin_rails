class AddNicknameToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :nickname, :string
  end
end
