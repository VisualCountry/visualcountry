require "rails_helper"

feature "Add and remove users from lists" do
  scenario "an admin can add a user to one of their lists" do
    admin = create(:admin)
    list = create(:influencer_list, owner: admin)
    profile = create(:profile)
    login_as(admin)

    visit profile_path(profile)
    select list.name, from: "test-influencer-list-select"
    click_on "test-add-to-influencer-list-submit"

    visit influencer_list_path(list)
    expect(page).to have_link profile.name
  end

  scenario "when a user is on a list, they can't be added to the list again" do
    admin = create(:admin)
    profile = create(:profile)
    list = create(:influencer_list, owner: admin, profiles: [profile])
    login_as(admin)

    visit profile_path(profile)

    expect(find_field("test-influencer-list-select")).to have_no_content list.name
  end

  scenario "an admin can remove a user from one of their lists" do
    admin = create(:admin)
    profile_1 = create(:profile)
    profile_2 = create(:profile)
    list = create(:influencer_list, owner: admin, profiles: [profile_1, profile_2])
    login_as(admin)

    visit influencer_list_path(list)
    within ".test-remove-user-#{profile_2.id}" do
      click_link "Remove"
    end

    expect(page).to have_link profile_1.name
    expect(page).to have_no_link profile_2.name
  end
end
