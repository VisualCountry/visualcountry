class AddTwitterTokenSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_token_secret, :string
  end
end
