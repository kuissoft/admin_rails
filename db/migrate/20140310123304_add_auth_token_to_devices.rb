class AddAuthTokenToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :auth_token, :string
    add_column :devices, :last_token, :string
    add_column :devices, :token_updated_at, :datetime
  end
end
