require "rails_helper"

describe ProfileSearchQuery do
  describe "searching by location" do
    it "returns profiles near a given location, if one is provided" do
      brooklyn_profile = create(:profile, city: "Brooklyn")
      la_profile = create(:profile, city: "Los Angeles")

      profiles_near_nyc = ProfileSearchQuery.new(near: "NYC").search

      expect(profiles_near_nyc).to include brooklyn_profile
      expect(profiles_near_nyc).not_to include la_profile
    end

    it "returns all profiles if the location is empty" do
      brooklyn_profile = create(:profile, city: "Brooklyn")
      la_profile = create(:profile, city: "Los Angeles")

      expect(ProfileSearchQuery.new.search).to include brooklyn_profile, la_profile
    end
  end
end
