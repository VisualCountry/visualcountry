require "rails_helper"

describe OrganizationMembership do
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to belong_to(:user) }
end
