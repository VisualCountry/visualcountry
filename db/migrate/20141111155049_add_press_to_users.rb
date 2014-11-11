class AddPressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :press, :string
  end
end
