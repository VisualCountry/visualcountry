require "rails_helper"

describe Organization do
  it { is_expected.to have_many(:organization_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:users) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe "#add_user" do
    it "adds a user to the organization" do
      organization = create(:organization)
      user = create(:user)

      organization.add_user(user)

      expect(organization.users).to include user
    end

    it "does nothing if the user is already in the organization" do
      user = create(:user)
      organization = create(:organization, users: [user])

      organization.add_user(user)

      expect(organization.users).to include user
    end
  end
end
