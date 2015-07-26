class ConvertUserJoinTablesToProfileJoinTables < ActiveRecord::Migration
  def change
    rename_table :clients_users, :clients_profiles
    rename_table :focuses_users, :focuses_profiles
    rename_table :interests_users, :interests_profiles

    rename_column :clients_profiles, :user_id, :profile_id
    rename_column :focuses_profiles, :user_id, :profile_id
    rename_column :interests_profiles, :user_id, :profile_id
  end
end
