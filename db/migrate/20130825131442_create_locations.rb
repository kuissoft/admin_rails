class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :session, index: true
      t.float :lat
      t.float :lon
      t.integer :bearing

      t.timestamps
    end
  end
end
