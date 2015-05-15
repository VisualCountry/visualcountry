require "rails_helper"

feature "After-signup flow" do
  scenario "a new user is guided through the after-signup flow" do
    bio = "Actuary"
    special_interests = "Fire poi"
    interest = create(:interest)

    user = build(:user)


    register_new_account(user)
    skip_social_profile_page
    add_basic_info(bio: bio)
    add_interests(interest, special_interests)

    visit edit_user_registration_path
    expect(page).to have_content user.name
    expect(page).to have_content bio
    visit profile_interests_path
    expect(checkbox_for_interest(interest).value).to eq("1")
    expect(page).to have_content special_interests
  end

  def register_new_account(user)
    visit new_user_registration_path
    fill_in "user_name", with: user.name
    fill_in "user_username", with: user.username
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password

    click_on "Sign up"
  end

  def skip_social_profile_page
    click_on "Continue"
  end

  def add_basic_info(bio)
    fill_in "user_bio", with: bio
    click_on "Save & Continue"
  end

  def add_interests(interest, special_interests)
    label_for_interest(interest).click
    fill_in "user_special_interests", with: special_interests
    click_on "Update Interests"
  end

  def label_for_interest(interest)
    find("label[for='user_interest_ids_#{interest.id}']")
  end

  def checkbox_for_interest(interest)
    find("#user_interest_ids_#{interest.id}", visible: false)
  end
end
