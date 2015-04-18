class ListMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :influencer_list

  validates :user_id, uniqueness: { scope: :influencer_list_id }
end
