class AddSmsDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sms_count, :integer, default: 0
    add_column :users, :reset_count, :integer, default: 0
  end
end
