require "rails_helper"

feature "Creating/updating/deleting influencer lists" do
  scenario "an admin can create an empty influencer list" do
    admin = create(:admin)
    list = build(:influencer_list)
    login_as(admin)

    visit new_influencer_list_path
    fill_in "Name", with: list.name
    click_on "Create"

    within ".list-name" do
      expect(page).to have_content list.name
    end
  end

  scenario "can view the users in a list" do
    admin = create(:admin)
    users = create_list(:user, 3)
    list = create(:influencer_list, owner: admin, users: users)

    visit influencer_list_path(list)

    users.each do |user|
      expect(page).to have_content user.name
    end
  end
end
