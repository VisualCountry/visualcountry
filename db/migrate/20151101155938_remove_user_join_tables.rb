class RemoveUserJoinTables < ActiveRecord::Migration
  def change
    remove_column :clients, :user_id
    remove_column :list_memberships, :user_id
    remove_column :presses, :user_id

    drop_table :clients_users
    drop_table :focuses_users
    drop_table :interests_users
  end
end
