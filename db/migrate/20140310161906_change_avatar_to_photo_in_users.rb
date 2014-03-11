class ChangeAvatarToPhotoInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :avatar_file_name, :photo_file_name
    rename_column :users, :avatar_content_type, :photo_content_type
    rename_column :users, :avatar_file_size, :photo_file_size
    rename_column :users, :avatar_updated_at, :photo_updated_at
  end
end
