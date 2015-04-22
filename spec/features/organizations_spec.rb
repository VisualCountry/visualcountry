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

  scenario "can see a list of all the organizations" do
    admin = create(:admin)
    organization_1 = create(:organization)
    organization_2 = create(:organization)
    login_as(admin)

    visit organizations_path

    expect(page).to have_link "New Organization"
    expect(page).to have_link organization_1.name
    expect(page).to have_link organization_2.name
  end

  scenario "can delete an organization" do
    admin = create(:admin)
    organization_1 = create(:organization)
    organization_2 = create(:organization)
    login_as(admin)

    visit organization_path(organization_1)
    click_on "Delete Organization"

    expect(page).to have_content "\"#{organization_1.name}\" deleted!"
    expect(page).to have_no_link organization_1.name
    expect(page).to have_link organization_2.name
  end
end
