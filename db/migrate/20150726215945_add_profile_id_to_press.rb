class AddProfileIdToPress < ActiveRecord::Migration
  def change
    add_column :presses, :profile_id, :integer
  end
end
