class OrganizationMembership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user

  validates :user_id, uniqueness: { scope: :organization_id }
end
