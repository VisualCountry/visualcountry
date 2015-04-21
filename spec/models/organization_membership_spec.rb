require "rails_helper"

describe OrganizationMembership do
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:organization_id) }
end
