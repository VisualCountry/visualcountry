require "rails_helper"

describe User do
  it { is_expected.to have_many(:influencer_lists).dependent(:destroy) }
  it { is_expected.to have_many(:list_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:organization_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:organizations) }

  describe "geocoding using AR callbacks from the geocoder gem" do
    it "saves the lat/lon of the user's location" do
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
      user = create(:user, city: "Peoria")

      expect(user.latitude).to eq latitude
      expect(user.longitude).to eq longitude
    end

    it "normalizes the name of the city" do
      user = create(:user, city: "NYC")

      expect(user.city).to eq "New York, NY"
    end

    it "performs geocoding when the address changes" do
      user = create(:user, city: "NYC")

      user.city = "New York City"

      expect(user).to receive(:normalize_city_name)
      user.save!
    end

    it "doesn't perform geocoding if the address doesn't change" do
      user = create(:user, city: "NYC")

      user.username = "New Username"

      expect(user).not_to receive(:normalize_city_name)
      user.save!
    end

    it "caches API requests in the Rails cache" do
      Rails.cache.clear
      user = create(:user, city: "NYC")

      expect(Rails.cache.fetch([:geocode, "NYC"])).to be_present
      expect(
        Rails.cache.fetch([:reverse_geocode, user.latitude, user.longitude])
      ).to be_present
    end
  end

  describe ".total_reach" do
    let(:total_user_count) { 10 }
    let(:total_follower_count) { 10000 }

    before do
      create_list :user, total_user_count, total_follower_count: total_follower_count
    end

    it "Returns the total reach of all users across Visual Country" do
      expect(User.total_reach).to eq total_user_count * total_follower_count
    end
  end

  describe "#lists_without" do
    it "returns the lists that the user's not on" do
      user = create(:user)
      member = create(:user)
      create(:influencer_list, owner: user, users: [member])
      empty_list = create(:influencer_list, owner: user)

      lists = user.lists_without(member)

      expect(lists).to eq [empty_list]
    end
  end

  describe "#list_membership_in" do
    it "returns a user's membership in the given list" do
      user = create(:user)
      list = create(:influencer_list)
      membership = create(:list_membership, user: user, influencer_list: list)

      expect(user.list_membership_in(list)).to eq membership
    end
  end

  describe "#organization_membership_in" do
    it "returns a user's membership in the given organization" do
      user = create(:user)
      organization = create(:organization)
      membership = create(
        :organization_membership,
        organization: organization,
        user: user,
      )

      expect(user.organization_membership_in(organization)).to eq membership
    end
  end

  describe "#owns_list?" do
    it "returns true if the user's the owner of the influencer list" do
      user = create(:user)
      list = create(:influencer_list, owner: user)

      expect(user.owns_list?(list)).to eq true
    end

    it "returns false if the user's not the owner of the influencer list" do
      user = create(:user)
      list = create(:influencer_list)

      expect(user.owns_list?(list)).to eq false
    end
  end

  describe "#can_manage_list" do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }
    let(:list) { create(:influencer_list) }
    before do
      organization.add_user user
    end
    context 'when the user is a member of an organization the list belongs to' do
      before do
        organization.add_list list
      end
      specify { expect(user.can_manage_list?(list)).to eq true }
    end
    context 'when the user is not a member of an organization the list belogns to' do
      specify { expect(user.can_manage_list?(list)).to eq false }
    end
  end
end
