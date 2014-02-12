class AddVerificationCodeInvalidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :verification_code_invalid_count, :integer, default: 0
  end
end
