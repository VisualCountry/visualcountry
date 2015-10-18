class OrganizationMembership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user #TODO: Remove after profile refactor
  belongs_to :profile

  validates :user_id, uniqueness: { scope: :organization_id } #TODO: Remove after profile refactor
  validates :profile_id, uniqueness: { scope: :organization_id }
end
