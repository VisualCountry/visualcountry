class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string  :username
      t.string  :name
      t.string  :city
      t.string  :bio, limit: 300
      t.text    :website
      t.integer :instagram_follower_count
      t.integer :twitter_follower_count
      t.integer :vine_follower_count
      t.integer :facebook_follower_count
      t.integer :pinterest_follower_count
      t.integer :total_follower_count
      t.integer :gender
      t.float   :latitude
      t.float   :longitude
      t.date    :birthday
      t.integer :ethnicity
      t.text    :special_interests

      t.string   :picture_file_name
      t.string   :picture_content_type
      t.integer  :picture_file_size
      t.datetime :picture_updated_at

      t.timestamps
    end
  end
end
