class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :password
      t.integer :type

      t.timestamps
    end
  end
end
