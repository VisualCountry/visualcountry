class ChangeUserIdForeignKeyToProfileId < ActiveRecord::Migration
  def change
    rename_column :presses, :user_id, :profile_id
    rename_column :influencer_lists, :user_id, :profile_id
    rename_column :list_memberships, :user_id, :profile_id
    rename_column :organization_memberships, :user_id, :profile_id
  end
end
