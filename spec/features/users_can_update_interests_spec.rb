require "rails_helper"

feature "Users can update profile interests" do
  scenario "as a user, I can update my special interests" do
    user = create(:user)
    interests = "sitting by the fireplace, walks on the beach, spongebob fanfic"
    login_as(user)

    visit profile_interests_path
    fill_in 'profile_special_interests', with: interests
    click_on 'Update User'

    visit profile_path(user.profile)
    expect(page).to have_content(interests)
  end
end
