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

  scenario "can view the profiles in a list" do
    admin = create(:admin)
    profiles = create_list(:profile, 3)
    list = create(:influencer_list, owner: admin, profiles: profiles)
    login_as(admin)

    visit influencer_list_path(list)

    profiles.each do |profile|
      expect(page).to have_link profile.name
    end
  end

  scenario "can see a list of all my lists" do
    admin = create(:admin)
    list_1 = create(:influencer_list, owner: admin)
    list_2 = create(:influencer_list, owner: admin)
    login_as(admin)

    visit influencer_lists_path

    expect(page).to have_link "New List"
    expect(page).to have_link list_1.name
    expect(page).to have_link list_2.name
  end

  scenario "can rename a list" do
    admin = create(:admin)
    list = create(:influencer_list, owner: admin)
    new_name = "My Favorite List"
    login_as(admin)

    visit influencer_list_path(list)
    click_link "Rename List"
    fill_in "Name", with: new_name
    click_on "Update"

    within ".list-name" do
      expect(page).to have_content new_name
    end
  end

  scenario "can delete a list" do
    admin = create(:admin)
    list_1 = create(:influencer_list, owner: admin)
    list_2 = create(:influencer_list, owner: admin)
    login_as(admin)

    visit influencer_list_path(list_1)
    click_on "Delete List"

    expect(page).to have_content "\"#{list_1.name}\" deleted!"
    expect(page).to have_no_link list_1.name
    expect(page).to have_link list_2.name
  end
end
