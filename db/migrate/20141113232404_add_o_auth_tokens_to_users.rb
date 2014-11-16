class AddOAuthTokensToUsers < ActiveRecord::Migration
  def change
    # Add a new column to the Users (:users) table called "facebook_token" (:facebook_token), and has a data type as text - type of string, integer
    add_column :users, :facebook_token, :text
    add_column :users, :twitter_token, :text
    add_column :users, :instagram_token, :text
    add_column :users, :pinterest_token, :text
  end
end
