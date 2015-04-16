require "rails_helper"

feature "Add users from search results" do
  scenario "admins can add search results to an existing influencer list" do
    admin = create(:admin)
    initial_user = create(:user)
    list = create(:influencer_list, owner: admin, users: [initial_user])
    young_user_1 = create(:user, birthday: 20.years.ago)
    young_user_2 = create(:user, birthday: 25.years.ago)
    old_user = create(:user, birthday: 70.years.ago)
    login_as(admin)

    visit profile_search_path
    fill_in "Max age", with: 30
    click_on "Save Search"
    select list.name, from: "Influencer list"
    click_on "Add"

    visit influencer_list_path(list)
    expect(page).to have_link initial_user.name
    expect(page).to have_link young_user_1.name
    expect(page).to have_link young_user_2.name
    expect(page).to have_no_link old_user.name
  end
end
