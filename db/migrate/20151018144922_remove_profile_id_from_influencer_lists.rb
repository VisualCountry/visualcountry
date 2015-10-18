class RemoveProfileIdFromInfluencerLists < ActiveRecord::Migration
  def change
    remove_column :influencer_lists, :profile_id, :integer
  end
end
