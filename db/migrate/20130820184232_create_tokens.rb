class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :token_id
      t.references :user, index: true
      t.references :session, index: true

      t.timestamps
    end
  end
end
