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

  scenario "can rename a organization" do
    admin = create(:admin)
    organization = create(:organization)
    new_name = "My Favorite Organization"
    login_as(admin)

    visit organization_path(organization)
    click_link "Rename Organization"
    fill_in "Name", with: new_name
    click_on "Update"

    within ".organization-name" do
      expect(page).to have_content new_name
    end
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

  scenario "can add an organization to a list" do
    admin = create(:admin)
    organization = create(:organization)
    list = create(:influencer_list)
    login_as(admin)

    visit organization_path(organization)
    select list.name, from: "Influencer list"
    click_on "Add List"

    expect(page).to have_link list.name
  end

  scenario "can remove a list from an organization" do
    admin = create(:admin)
    list_1 = create(:influencer_list)
    list_2 = create(:influencer_list)
    organization = create(:organization, influencer_lists: [list_1, list_2])
    login_as(admin)

    visit organization_path(organization)
    within ".influencer-list-#{list_2.id}" do
      click_on "Remove"
    end

    expect(page).to have_content list_1.name
    expect(page).to have_no_link list_2.name
  end
end
