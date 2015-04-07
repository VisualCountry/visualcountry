require "rails_helper"

feature "Searching User profiles" do
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
