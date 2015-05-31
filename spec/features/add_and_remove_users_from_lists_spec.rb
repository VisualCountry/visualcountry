require "rails_helper"

feature "Add and remove users from lists" do
  scenario "an admin can add a user to one of their lists" do
    admin = create(:admin)
    list = create(:influencer_list, owner: admin)
    user = create(:user)
    login_as(admin)

    visit profile_path(user)
    select list.name, from: "test-influencer-list-select"
    click_on "test-add-to-influencer-list-submit"

    visit influencer_list_path(list)
    expect(page).to have_link user.name
  end

  scenario "when a user is on a list, they can't be added to the list again" do
    admin = create(:admin)
    user = create(:user)
    list = create(:influencer_list, owner: admin, users: [user])
    login_as(admin)

    visit profile_path(user)

    expect(find_field("test-influencer-list-select")).to have_no_content list.name
  end

  scenario "an admin can remove a user from one of their lists" do
    admin = create(:admin)
    user_1 = create(:user)
    user_2 = create(:user)
    list = create(:influencer_list, owner: admin, users: [user_1, user_2])
    login_as(admin)

    visit influencer_list_path(list)
    within ".test-remove-user-#{user_2.id}" do
      click_link "Remove"
    end

    expect(page).to have_link user_1.name
    expect(page).to have_no_link user_2.name
  end
end
