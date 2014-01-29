class ChangeSettings < ActiveRecord::Migration
  def change
    remove_column :settings, :token_expiration_period
    add_column :settings, :name, :string
    add_column :settings, :value, :text
  end
end
