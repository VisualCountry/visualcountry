require "rails_helper"

describe OrganizationListMembership do
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to belong_to(:influencer_list) }
  it { is_expected.to validate_uniqueness_of(:organization_id).scoped_to(:influencer_list_id) }
end
