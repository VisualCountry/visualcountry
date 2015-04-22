require "rails_helper"

describe Organization do
  it { is_expected.to have_many(:organization_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:organization_list_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:influencer_lists) }

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

  describe "#add_list" do
    it "adds a user to the organization" do
      list = create(:influencer_list)
      organization = create(:organization)

      organization.add_list(list)

      expect(organization.influencer_lists).to include list
    end

    it "does nothing if the list is already in the organization" do
      list = create(:influencer_list)
      organization = create(:organization, influencer_lists: [list])

      organization.add_list(list)

      expect(organization.influencer_lists).to include list
    end
  end
end
