require "rails_helper"

describe ProfileSearchQuery do
  describe "searching by location" do
    it "returns users near a given location, if one is provided" do
      brooklyn_user = create(:user, city: "Brooklyn")
      la_user = create(:user, city: "Los Angeles")

      users_near_nyc = ProfileSearchQuery.new(near: "NYC").search

      expect(users_near_nyc).to include brooklyn_user
      expect(users_near_nyc).not_to include la_user
    end

    it "returns all users if the location is empty" do
      brooklyn_user = create(:user, city: "Brooklyn")
      la_user = create(:user, city: "Los Angeles")

      expect(ProfileSearchQuery.new.search).to include brooklyn_user, la_user
    end
  end
end
