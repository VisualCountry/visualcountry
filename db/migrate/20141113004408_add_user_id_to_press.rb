class AddUserIdToPress < ActiveRecord::Migration
  def change
    add_column :presses, :user_id, :integer
  end
end
