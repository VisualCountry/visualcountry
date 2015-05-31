require "rails_helper"

feature "Users are in organizations" do
  scenario "a user's organizations are listed on their profile" do
    user = create(:user)
    organization_1 = create(:organization, users: [user])
    organization_2 = create(:organization, users: [user])
    login_as(user)

    visit profile_path(user)

    expect(page).to have_link organization_1.name
    expect(page).to have_link organization_2.name
  end

  scenario "an admin can add a user to an organization" do
    admin = create(:admin)
    user = create(:user)
    organization = create(:organization)
    login_as(admin)

    visit profile_path(user)
    select organization.name, from: "test-add-to-organization-form"
    click_on "test-add-to-organization-submit"

    visit organization_path(organization)
    expect(page).to have_link user.name
  end

  scenario "an admin can remove a user from an organization" do
    admin = create(:admin)
    user = create(:user)
    organization = create(:organization, users: [user])
    login_as(admin)

    visit organization_path(organization)
    find("[role='remove_user_from_organization']").click

    expect(page).to have_no_link user.name
  end

  scenario "an organization's users are listed on its show page" do
    admin = create(:admin)
    user = create(:user)
    organization = create(:organization, users: [admin, user])
    login_as(admin)

    visit organization_path(organization)

    expect(page).to have_link admin.name
    expect(page).to have_link user.name
  end
end
