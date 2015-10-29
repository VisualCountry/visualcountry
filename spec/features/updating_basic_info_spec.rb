require 'rails_helper'

feature 'Updating profile infomation' do
  scenario 'a user can update their basic info' do
    user = create(:user)
    new_attrs = build(
      :profile,
      name: "Dade Murphy",
      website: "http://example.com",
      birthday: DateTime.new(1995, 9, 15),
      gender: "Male",
      ethnicity: "White",
    )
    login_as(user)

    visit profile_basic_info_path
    fill_in("Website", with: new_attrs.website)
    select(new_attrs.gender, from: "Gender")
    select(new_attrs.ethnicity, from: "Ethnicity")
    select(new_attrs.birthday.strftime("%Y"), from: "profile_birthday_1i")
    select(new_attrs.birthday.strftime("%B"), from: "profile_birthday_2i")
    select(new_attrs.birthday.strftime("%e"), from: "profile_birthday_3i")
    click_on "test-update-user-submit"

    visit profile_basic_info_path
    expect(page).to have_field("Website", new_attrs.website)
    expect(page).to have_select("Gender", selected: new_attrs.gender)
    expect(page).to have_select("Ethnicity", selected: new_attrs.ethnicity)
    expect(page).to have_select("profile_birthday_1i", selected: new_attrs.birthday.strftime("%Y"))
    expect(page).to have_select("profile_birthday_2i", selected: new_attrs.birthday.strftime("%B"))
    expect(page).to have_select("profile_birthday_3i", selected: new_attrs.birthday.strftime("%e"))
  end
end
