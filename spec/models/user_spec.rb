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
  end
end
