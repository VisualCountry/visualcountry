class OrganizationMembership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :profile

  validates :profile_id, uniqueness: { scope: :organization_id }
end
