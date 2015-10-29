require "rails_helper"

feature "Add profiles from search results" do
  scenario "admins can add search results to an existing influencer list" do
    admin = create(:admin)
    initial_profile = create(:profile)
    list = create(:influencer_list, owner: admin, profiles: [initial_profile])
    young_profile_1 = create(:profile, birthday: 20.years.ago)
    young_profile_2 = create(:profile, birthday: 25.years.ago)
    old_profile = create(:profile, birthday: 70.years.ago)
    login_as(admin)

    visit profile_search_path
    fill_in "test-max-age", with: 30
    click_button "Search"
    select list.name, from: "test-influencer-list-selection"
    click_on "test-influencer-list-submit"

    visit influencer_list_path(list)
    expect(page).to have_link initial_profile.name
    expect(page).to have_link young_profile_1.name
    expect(page).to have_link young_profile_2.name
    expect(page).to have_no_link old_profile.name
  end
end
