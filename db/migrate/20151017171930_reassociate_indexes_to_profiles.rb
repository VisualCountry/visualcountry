class ReassociateIndexesToProfiles < ActiveRecord::Migration
  def change
    add_index :clients_profiles, [:client_id, :profile_id], unique: true
    add_index :focuses_profiles, [:focus_id, :profile_id], unique: true
    add_index :list_memberships, :profile_id
    add_index :organization_memberships, :profile_id
  end
end
