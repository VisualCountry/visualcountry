class AddProfileIdToInfluencerLists < ActiveRecord::Migration
  def change
    add_column :influencer_lists, :profile_id, :integer
  end
end
