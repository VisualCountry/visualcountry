require "rails_helper"

describe "Creating/updating/deleting organizations" do
  scenario "an admin can create an empty organization" do
    admin = create(:admin)
    organization = build(:organization)
    login_as(admin)

    visit new_organization_path
    fill_in "Name", with: organization.name
    click_on "Create"

    within ".organization-name" do
      expect(page).to have_content organization.name
    end
  end
end
