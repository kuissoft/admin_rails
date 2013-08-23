class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.text :session_id
      t.references :sender, index: true
      t.references :recipient, index: true

      t.timestamps
    end
  end
end
