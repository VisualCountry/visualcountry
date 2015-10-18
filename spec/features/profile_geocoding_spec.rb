require "rails_helper"

feature "User addresses are normalized through reverse geocoding" do
  scenario "translates 'NYC' to 'New York, NY'" do
    user = create(:user)
    user.reload
    login_as(user)

    visit profile_basic_info_path
    fill_in("City", with: "NYC")
    click_on "test-update-user-submit"

    visit profile_path(user)
    within "[data-role='geo-contact']" do
      expect(page).to have_content "New York, NY"
    end
  end
end
