class ListMembership < ActiveRecord::Base
  belongs_to :profile
  belongs_to :influencer_list

  validates :profile_id, uniqueness: { scope: :influencer_list_id }
end
