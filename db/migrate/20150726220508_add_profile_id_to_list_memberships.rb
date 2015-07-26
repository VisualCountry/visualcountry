class AddProfileIdToListMemberships < ActiveRecord::Migration
  def change
    add_column :list_memberships, :profile_id, :integer
  end
end
