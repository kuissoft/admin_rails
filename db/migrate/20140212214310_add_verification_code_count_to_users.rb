class AddVerificationCodeCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :verification_code_sent_count, :integer, default: 0
  end
end
