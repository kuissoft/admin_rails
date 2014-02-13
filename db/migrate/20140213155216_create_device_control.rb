class CreateDeviceControl < ActiveRecord::Migration
  def change
    create_table :device_controls do |t|
      t.string :uuid
      t.string :verification_code
      t.boolean :resent, default: false
      t.string :phone
      t.integer :invalid, default: 0
    end
  end
end
