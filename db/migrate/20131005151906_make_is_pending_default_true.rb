class MakeIsPendingDefaultTrue < ActiveRecord::Migration
  def change
    change_column :connections, :is_pending, :bool, default: true
  end
end
