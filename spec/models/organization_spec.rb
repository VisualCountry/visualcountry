require "rails_helper"

describe Organization do
  it { is_expected.to have_many(:organization_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:profiles) }
  it { is_expected.to have_many(:organization_list_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:influencer_lists) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe "#add_profile" do
    it "adds a profile to the organization" do
      organization = create(:organization)
      profile = create(:profile)

      organization.add_profile(profile)

      expect(organization.profiles).to include profile
    end

    it "does nothing if the profile is already in the organization" do
      profile = create(:profile)
      organization = create(:organization, profiles: [profile])

      organization.add_profile(profile)

      expect(organization.profiles).to include profile
    end
  end

  describe "#add_list" do
    it "adds a profile to the organization" do
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
