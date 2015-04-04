class AddTwitterUidToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_uid, :text
  end
end
