class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :token_expiration_period

      t.timestamps
    end
  end
end
