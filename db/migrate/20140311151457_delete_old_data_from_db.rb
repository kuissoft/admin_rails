class DeleteOldDataFromDb < ActiveRecord::Migration
  def change
    drop_table :device_controls
    remove_column :users, :auth_token
    remove_column :users, :last_token
    remove_column :users, :token_updated_at
    remove_column :users, :validation_code
    remove_column :users, :verification_code_sent_count
    remove_column :users, :verification_code_invalid_count
  end
end
