class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.time :time_from
      t.time :time_until

      t.timestamps
    end
  end
end
