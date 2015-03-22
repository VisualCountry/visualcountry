class AddTotalFollowerCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :total_follower_count, :integer
  end
end
