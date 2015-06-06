class AddFacebookUidToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :text
  end
end
