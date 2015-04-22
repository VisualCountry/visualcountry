class CreateOrganizationListMemberships < ActiveRecord::Migration
  def change
    create_table :organization_list_memberships do |t|
      t.timestamps

      t.references :influencer_list, null: false, index: true
      t.references :organization, null: false, index: true
    end
  end
end
