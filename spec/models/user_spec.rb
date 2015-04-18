require "rails_helper"

describe User do
  it { is_expected.to have_many(:influencer_lists).dependent(:destroy) }

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

  describe "#membership_in" do
    it "returns a user's membership in the given list" do
      user = create(:user)
      list = create(:influencer_list)
      membership = create(:list_membership, user: user, influencer_list: list)

      expect(user.membership_in(list)).to eq membership
    end
  end
end
