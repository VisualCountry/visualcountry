require 'rails_helper'

RSpec.describe Profile do
  it { is_expected.to have_many(:influencer_lists).dependent(:destroy) }
  it { is_expected.to have_many(:list_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:organization_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:organizations) }

  describe "geocoding using AR callbacks from the geocoder gem" do
    it "saves the lat/lon of the profile's location" do
      latitude = 40.6936488
      longitude = -89.5889864
      Geocoder::Lookup::Test.add_stub(
        "Peoria",
        [
          {
            latitude: latitude,
            longitude: longitude,
          }
        ]
      )
      Geocoder::Lookup::Test.add_stub(
        [latitude, longitude],
        [
          {
            city: "Peoria",
            state_code: "IL",
          }
        ]
      )
      profile = create(:profile, city: "Peoria")

      expect(profile.latitude).to eq latitude
      expect(profile.longitude).to eq longitude
    end

    it "normalizes the name of the city" do
      profile = create(:profile, city: "NYC")

      expect(profile.city).to eq "New York, NY"
    end

    it "performs geocoding when the address changes" do
      profile = create(:profile, city: "NYC")

      profile.city = "New York City"

      expect(profile).to receive(:normalize_city_name)
      profile.save!
    end

    it "doesn't perform geocoding if the address doesn't change" do
      profile = create(:profile, city: "NYC")

      profile.username = "New Username"

      expect(profile).not_to receive(:normalize_city_name)
      profile.save!
    end

    it "caches API requests in the Rails cache" do
      Rails.cache.clear
      profile = create(:profile, city: "NYC")

      expect(Rails.cache.fetch([:geocode, "NYC"])).to be_present
      expect(
        Rails.cache.fetch([:reverse_geocode, profile.latitude, profile.longitude])
      ).to be_present
    end
  end

  describe ".total_reach" do
    let(:total_user_count) { 10 }
    let(:total_follower_count) { 10000 }

    before do
      create_list :profile, total_user_count, total_follower_count: total_follower_count
    end

    it "Returns the total reach of all profiles across Visual Country" do
      expect(Profile.total_reach).to eq total_user_count * total_follower_count
    end
  end

  describe "#lists_without" do
    it "returns the lists that the profile's not on" do
      profile = create(:profile)
      member = create(:profile)
      create(:influencer_list, owner: profile, profiles: [member])
      empty_list = create(:influencer_list, owner: profile)

      lists = profile.lists_without(member)

      expect(lists).to eq [empty_list]
    end
  end

  describe "#list_membership_in" do
    it "returns a profile's membership in the given list" do
      profile = create(:profile)
      list = create(:influencer_list)
      membership = create(:list_membership, profile: profile, influencer_list: list)

      expect(profile.list_membership_in(list)).to eq membership
    end
  end

  describe "#organization_membership_in" do
    it "returns a profile's membership in the given organization" do
      profile = create(:profile)
      organization = create(:organization)
      membership = create(
        :organization_membership,
        organization: organization,
        profile: profile,
      )

      expect(profile.organization_membership_in(organization)).to eq membership
    end
  end

  describe "#owns_list?" do
    it "returns true if the profile's the owner of the influencer list" do
      profile = create(:profile)
      list = create(:influencer_list, owner: profile)

      expect(profile.owns_list?(list)).to eq true
    end

    it "returns false if the profile's not the owner of the influencer list" do
      profile = create(:profile)
      list = create(:influencer_list)

      expect(profile.owns_list?(list)).to eq false
    end
  end

  describe "#can_manage_list" do
    let(:organization) { create(:organization) }
    let(:profile) { create(:profile) }
    let(:list) { create(:influencer_list) }
    before do
      organization.add_profile profile
    end
    context 'when the profile is a member of an organization the list belongs to' do
      before do
        organization.add_list list
      end
      specify { expect(profile.can_manage_list?(list)).to eq true }
    end
    context 'when the profile is not a member of an organization the list belogns to' do
      specify { expect(profile.can_manage_list?(list)).to eq false }
    end
  end
end
