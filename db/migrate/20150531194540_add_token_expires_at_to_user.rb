class AddTokenExpiresAtToUser < ActiveRecord::Migration
  def change
    rename_column :users, :facebook_token_expiration, :facebook_token_expires_at
    add_column :users, :instagram_token_expires_at, :datetime
    add_column :users, :twitter_token_expires_at, :datetime
    add_column :users, :vine_token_expires_at, :datetime
    add_column :users, :pinterest_token_expires_at, :datetime
  end
end
