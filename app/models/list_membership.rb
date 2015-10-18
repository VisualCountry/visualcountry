class ListMembership < ActiveRecord::Base
  belongs_to :user #TODO: Remove after profile refactor
  belongs_to :profile
  belongs_to :influencer_list

  validates :user_id, uniqueness: { scope: :influencer_list_id } #TODO: Remove after profile refactor
  validates :profile_id, uniqueness: { scope: :influencer_list_id }
end
