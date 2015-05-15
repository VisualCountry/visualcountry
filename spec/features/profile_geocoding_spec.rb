require "rails_helper"

feature "User addresses are normalized through reverse geocoding" do
  scenario "translates 'NYC' to 'New York, NY'" do
    user = create(:user)
    login_as(user)

    visit edit_user_registration_path
    fill_in("City", with: "NYC")
    fill_in(
      "Password (leave blank if you don't want to change it)",
      with: user.password,
    )
    fill_in("Password confirmation", with: user.password)
    click_on "Save & Continue"

    visit profile_path(user)
    within "[data-role='geo-contact']" do
      expect(page).to have_content "New York, NY"
    end
  end
end
