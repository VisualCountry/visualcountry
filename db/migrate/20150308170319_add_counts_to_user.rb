class AddCountsToUser < ActiveRecord::Migration
  def change
    add_column :users, :cached_instagram_follower_count, :integer
    add_column :users, :cached_twitter_follower_count, :integer
    add_column :users, :cached_vine_follower_count, :integer
    add_column :users, :cached_facebook_follower_count, :integer
    add_column :users, :cached_pinterest_follower_count, :integer
  end
end
