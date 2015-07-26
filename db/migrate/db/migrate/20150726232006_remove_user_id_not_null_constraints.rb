class RemoveUserIdNotNullConstraints < ActiveRecord::Migration
  def up
    change_column :influencer_lists, :user_id, :integer, null: true
    change_column :list_memberships, :user_id, :integer, null: true
    change_column :organization_memberships, :user_id, :integer, null: true
  end

  def down
    change_column :influencer_lists, :user_id, :integer, null: false
    change_column :list_memberships, :user_id, :integer, null: false
    change_column :organization_memberships, :user_id, :integer, null: false
  end
end
