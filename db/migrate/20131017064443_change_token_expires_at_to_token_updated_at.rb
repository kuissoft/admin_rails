class ChangeTokenExpiresAtToTokenUpdatedAt < ActiveRecord::Migration
  def change
    rename_column :users, :token_expires_at, :token_updated_at
  end
end
