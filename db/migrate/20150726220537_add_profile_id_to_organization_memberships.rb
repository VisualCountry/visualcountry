class AddProfileIdToOrganizationMemberships < ActiveRecord::Migration
  def change
    add_column :organization_memberships, :profile_id, :integer
  end
end
