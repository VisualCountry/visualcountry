require "rails_helper"

feature "After-signup flow" do
  scenario "a new user is guided through the after-signup flow" do
    user = build(:user)
    bio = "Actuary"
    special_interests = "Fire poi"
    interest = create(:interest)

    register_new_account(user)
    skip_social_profile_page
    add_basic_info(bio: bio)
    add_interests(interest, special_interests)

    visit edit_user_registration_path
    expect(page).to have_content user.name
    expect(page).to have_content bio
    visit profile_interests_path
    expect(page).to have_checked_field interest.name
    expect(page).to have_content special_interests
  end

  def register_new_account(user)
    visit new_user_registration_path
    fill_in "Name", with: user.name
    fill_in "Username", with: user.username
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_on "Sign up"
  end

  def skip_social_profile_page
    click_on "Skip"
  end

  def add_basic_info(bio)
    fill_in "Bio", with: bio
    click_on "Update my account"
  end

  def add_interests(interest, special_interests)
    check interest.name
    fill_in "Special interests", with: special_interests
    click_on "Update Interests"
  end
end
