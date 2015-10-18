require "rails_helper"

describe InfluencerList do
  it { is_expected.to belong_to :owner }
  it { is_expected.to have_many(:list_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:profiles).through(:list_memberships) }
  it { is_expected.to have_many(:organization_list_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:organizations) }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  describe "#add_profile" do
    it "adds a profile to the list" do
      list = create(:influencer_list)
      profile = create(:profile)

      list.add_profile(profile)

      expect(list.profiles).to include profile
    end

    it "does nothing if the profile is already on the list" do
      profile = create(:profile)
      list = create(:influencer_list, profiles: [profile])

      list.add_profile(profile)

      expect(list.profiles).to include profile
    end
  end

  describe "#add_profiles" do
    it "adds the profiles that aren't already on the list" do
      old_profiles = create_list(:profile, 2)
      list = create(:influencer_list, profiles: old_profiles)
      new_profile = create(:profile)

      list.add_profiles([old_profiles.first, new_profile])

      expect(list.profiles).to include new_profile, *old_profiles
    end
  end

  describe "#remove_profile" do
    it "removes a profile from the list" do
      profile = create(:profile)
      list = create(:influencer_list, profiles: [profile])

      list.remove_profile(profile)

      expect(list.profiles).not_to include profile
    end
  end

  describe "#organization_membership" do
    it "returns the membership between the list and the organization" do
      list = create(:influencer_list)
      organization = create(:organization)
      membership = create(
        :organization_list_membership,
        influencer_list: list,
        organization: organization,
      )

      expect(list.organization_membership(organization)).to eq membership
    end
  end
end
