class RemoveProfileAttributesFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :username
    remove_column :users, :name
    remove_column :users, :city
    remove_column :users, :bio
    remove_column :users, :picture_file_name
    remove_column :users, :picture_content_type
    remove_column :users, :picture_file_size
    remove_column :users, :picture_updated_at
    remove_column :users, :website
    remove_column :users, :cached_instagram_follower_count
    remove_column :users, :cached_twitter_follower_count
    remove_column :users, :cached_vine_follower_count
    remove_column :users, :cached_facebook_follower_count
    remove_column :users, :cached_pinterest_follower_count
    remove_column :users, :total_follower_count
    remove_column :users, :gender
    remove_column :users, :latitude
    remove_column :users, :longitude
    remove_column :users, :birthday
    remove_column :users, :ethnicity
    remove_column :users, :special_interests
  end
end
