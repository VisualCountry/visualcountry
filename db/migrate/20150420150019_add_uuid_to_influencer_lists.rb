class AddUuidToInfluencerLists < ActiveRecord::Migration
  def change
    add_column :influencer_lists, :uuid, :string, index: true
  end
end
