require "rails_helper"

feature "Searching User profiles" do
  feature "searching by location" do
    scenario "specifying a location only retrieves users near that location" do
      brooklyn_user = create(:user, city: "Brooklyn")
      la_user = create(:user, city: "Los Angeles")

      visit profile_search_path
      fill_in "Near", with: "NYC"
      click_on "Save Search"

      expect(page).to have_content brooklyn_user.name
      expect(page).to have_no_content la_user.name
    end

    scenario "not specifying a location searches all users" do
      brooklyn_user = create(:user, city: "Brooklyn")
      la_user = create(:user, city: "Los Angeles")

      visit profile_search_path
      click_on "Save Search"

      expect(page).to have_content brooklyn_user.name
      expect(page).to have_content la_user.name
    end
  end

  feature "searching by gender" do
    scenario "specifying a gender only retrieves users with that gender" do
      male_user = create(:user, gender: "Male")
      female_user = create(:user, gender: "Female")

      visit profile_search_path
      select("Male", from: "Gender")
      click_on "Save Search"

      expect(page).to have_content male_user.name
      expect(page).to have_no_content female_user.name
    end

    scenario "not specifying a gender searches all users" do
      male_user = create(:user, gender: "Male")
      female_user = create(:user, gender: "Female")

      visit profile_search_path
      click_on "Save Search"

      expect(page).to have_content male_user.name
      expect(page).to have_content female_user.name
    end
  end

  feature "searching by ethnicity" do
    scenario "specifying an ethnicity only retrieves users with that ethnicity" do
      hispanic_user = create(:user, ethnicity: "Hispanic or Latino")
      asian_user = create(:user, ethnicity: "Asian")

      visit profile_search_path
      select("Hispanic or Latino", from: "Ethnicity")
      click_on "Save Search"

      expect(page).to have_content hispanic_user.name
      expect(page).to have_no_content asian_user.name
    end

    scenario "not specifying an ethnicity searches all users" do
      hispanic_user = create(:user, ethnicity: "Hispanic or Latino")
      asian_user = create(:user, ethnicity: "Asian")

      visit profile_search_path
      click_on "Save Search"

      expect(page).to have_content hispanic_user.name
      expect(page).to have_content asian_user.name
    end
  end

  feature "searching by age" do
    scenario "specifying a minimum age only returns older users" do
      age_20_user = create(:user, birthday: 20.years.ago)
      age_30_user = create(:user, birthday: 30.years.ago)

      visit profile_search_path
      fill_in "Min age", with: 25
      click_on "Save Search"

      expect(page).to have_content age_30_user.name
      expect(page).to have_no_content age_20_user.name
    end

    scenario "specifying a maximum age only returns younger users" do
      age_20_user = create(:user, birthday: 20.years.ago)
      age_30_user = create(:user, birthday: 30.years.ago)

      visit profile_search_path
      fill_in "Max age", with: 25
      click_on "Save Search"

      expect(page).to have_content age_20_user.name
      expect(page).to have_no_content age_30_user.name
    end

    scenario "not specifying an age returns all users" do
      age_20_user = create(:user, birthday: 20.years.ago)
      age_30_user = create(:user, birthday: 30.years.ago)

      visit profile_search_path
      click_on "Save Search"

      expect(page).to have_content age_20_user.name
      expect(page).to have_content age_30_user.name
    end
  end
end
