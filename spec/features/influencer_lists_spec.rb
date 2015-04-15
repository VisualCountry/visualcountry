require "rails_helper"

feature "Creating/updating/deleting influencer lists" do
  scenario "An admin can create an empty influencer list" do
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
end
