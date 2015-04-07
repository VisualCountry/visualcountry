require "rails_helper"

describe User do
  describe "geocoding" do
    it "saves the lat/lon of the user's location" do
      user = create(:user, city: "NYC")

      expect(user.latitude).to be_within(0.1).of(40.7)
      expect(user.longitude).to be_within(0.1).of(-74.0)
    end

    it "normalizes the name of the city" do
      user = create(:user, city: "NYC")

      expect(user.city).to eq "New York, NY"
    end

    it "performs geocoding when the address changes" do
      user = create(:user, city: "NYC")

      user.city = "New York City"

      expect(user).to receive(:geocode)
      expect(user).to receive(:reverse_geocode)
      user.save!
    end

    it "doesn't perform geocoding if the address doesn't change" do
      user = create(:user, city: "NYC")

      user.username = "New Username"

      expect(user).not_to receive(:geocode)
      expect(user).not_to receive(:reverse_geocode)
      user.save!
    end
  end
end
