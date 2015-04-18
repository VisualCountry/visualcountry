class CreateListMemberships < ActiveRecord::Migration
  def change
    create_table :list_memberships do |t|
      t.belongs_to :user, null: false, index: true
      t.belongs_to :influencer_list, null: false, index: true

      t.timestamps
    end
  end
end
