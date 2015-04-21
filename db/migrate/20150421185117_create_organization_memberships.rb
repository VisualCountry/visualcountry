class CreateOrganizationMemberships < ActiveRecord::Migration
  def change
    create_table :organization_memberships do |t|
      t.timestamps

      t.references :user, null: false, index: true
      t.references :organization, null: false, index: true
    end
  end
end
