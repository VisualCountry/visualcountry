class AddUuidToInfluencerLists < ActiveRecord::Migration
  def change
    add_column :influencer_lists, :uuid, :string, null: false, index: true
  end
end
