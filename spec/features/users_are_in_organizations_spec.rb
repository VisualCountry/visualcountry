require "rails_helper"

feature "Users are in organizations" do
  scenario "a user's organizations are listed on their profile" do
    user = create(:user)
    organization_1 = create(:organization, users: [user])
    organization_2 = create(:organization, users: [user])

    visit profile_path(user)

    expect(page).to have_content organization_1.name
    expect(page).to have_content organization_2.name
  end

  scenario "an organization's users are listed on its show page" do
    user_1 = create(:user)
    user_2 = create(:user)
    organization = create(:organization, users: [user_1, user_2])

    visit organization_path(organization)

    expect(page).to have_content user_1.name
    expect(page).to have_content user_2.name
  end
end
