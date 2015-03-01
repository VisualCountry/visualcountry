class AddVineTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vine_token, :text
  end
end
