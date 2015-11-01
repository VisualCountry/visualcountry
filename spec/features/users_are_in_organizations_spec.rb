require "rails_helper"

feature "Users are in organizations" do
  scenario "a user's organizations are listed on their profile" do
    user = create(:user)
    organization_1 = create(:organization, profiles: [user.profile])
    organization_2 = create(:organization, profiles: [user.profile])
    login_as(user)

    visit profile_path(user.profile)

    expect(page).to have_link organization_1.name
    expect(page).to have_link organization_2.name
  end

  scenario "an admin can add a user to an organization" do
    admin = create(:admin)
    user = create(:user)
    organization = create(:organization)
    login_as(admin)

    visit profile_path(user.profile)
    select organization.name, from: "test-add-to-organization-form"
    click_on "test-add-to-organization-submit"

    visit organization_path(organization)
    expect(page).to have_link user.profile.name
  end

  scenario "an admin can remove a user from an organization" do
    admin = create(:admin)
    profile = create(:profile)
    organization = create(:organization, profiles: [profile])
    login_as(admin)

    visit organization_path(organization)
    find("[role='remove_user_from_organization']").click

    expect(page).to have_no_link profile.name
  end

  scenario "an organization's profiles are listed on its show page" do
    admin = create(:admin)
    user = create(:user)
    organization = create(:organization, profiles: [admin.profile, user.profile])
    login_as(admin)

    visit organization_path(organization)

    expect(page).to have_link admin.profile.name
    expect(page).to have_link user.profile.name
  end
end
