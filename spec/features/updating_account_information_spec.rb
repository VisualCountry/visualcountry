require 'rails_helper'

feature 'Updating account infomation' do
  scenario 'a user can update their properties' do
    user = create(:user)
    new_attrs = build(:user, email: 'crashoverride@example.com')
    login_as(user)

    visit edit_user_registration_path
    fill_in("Email", with: new_attrs.email)
    fill_in_password("password")
    click_on "test-update-user-submit"

    visit edit_user_registration_path
    expect(page).to have_field("Email", new_attrs.email)
  end

  def fill_in_password(password)
    fill_in(
      "Password (leave blank if you don't want to change it)",
      with: password,
    )
    fill_in("Password confirmation", with: password)
  end
end
