class DeviceMerge < ActiveRecord::Migration
  def change
    add_column :devices, :uuid, :string
    add_column :devices, :phone, :string
    add_column :devices, :language, :string, :default => 'en'
    add_column :devices, :verification_code, :string
    add_column :devices, :invalid_count, :integer, default: 0
    add_column :devices, :resent, :boolean, default: false
    add_column :devices, :resent_at, :datetime
    add_column :devices, :sms_count, :integer, default: 0
    add_column :devices, :reset_count, :integer, default: 0
  end
end
