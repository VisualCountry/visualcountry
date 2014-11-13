class RemovePressFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :press
  end
end
