class OrganizationListMembership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :influencer_list

  validates :organization_id, uniqueness: { scope: :influencer_list_id }
end
