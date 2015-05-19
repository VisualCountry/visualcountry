class AddLimitToUserBio < ActiveRecord::Migration
  def change
    change_column :users, :bio, :string, :limit => 300
  end
end
