class AddProfileIdForeignKeys < ActiveRecord::Migration
  def change
    add_column :presses, :profile_id, :integer
    add_column :list_memberships, :profile_id, :integer
    add_column :organization_memberships, :profile_id, :integer
    add_column :influencer_lists, :profile_id, :integer
  end
end
