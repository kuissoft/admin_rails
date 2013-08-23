class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.text :token_id
      t.references :user, index: true
      t.references :session, index: true

      t.timestamps
    end
  end
end
