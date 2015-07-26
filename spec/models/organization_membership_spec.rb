require "rails_helper"

describe OrganizationMembership do
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to belong_to(:profile) }
  it { is_expected.to validate_uniqueness_of(:profile_id).scoped_to(:organization_id) }
end
