class ReassociateIndexes < ActiveRecord::Migration
  def change
    remove_index :clients_users, [:client_id, :user_id]
    remove_index :focuses_users, [:focus_id, :user_id]
    remove_index :list_memberships, :user_id
    remove_index :organization_memberships, :user_id

    add_index :clients_profiles, [:client_id, :profile_id], unique: true
    add_index :focuses_profiles, [:focus_id, :profile_id], unique: true
    add_index :list_memberships, :profile_id
    add_index :organization_memberships, :profile_id
  end
end
