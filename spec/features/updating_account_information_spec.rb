require "rails_helper"

feature "Updating account infomation" do
  scenario "a user can update their properties" do
    user = create(:user)
    new_attrs = build(
      :user,
      name: "Dade Murphy",
      email: "crashoverride@example.com",
      website: "http://example.com",
      birthday: DateTime.new(1995, 9, 15),
      gender: "Male",
      ethnicity: "White",
    )
    login_as(user)

    visit edit_user_registration_path
    fill_in("Website", with: new_attrs.website)
    fill_in("Email", with: new_attrs.email)
    select(new_attrs.gender, from: "Gender")
    select(new_attrs.ethnicity, from: "Ethnicity")
    select(new_attrs.birthday.strftime("%Y"), from: "user_birthday_1i")
    select(new_attrs.birthday.strftime("%B"), from: "user_birthday_2i")
    select(new_attrs.birthday.strftime("%e"), from: "user_birthday_3i")
    fill_in_password("password")
    click_on "Update my account"

    expect(page).to have_field("Website", new_attrs.website)
    expect(page).to have_field("Email", new_attrs.email)
    expect(page).to have_select("Gender", selected: new_attrs.gender)
    expect(page).to have_select("Ethnicity", selected: new_attrs.ethnicity)
    expect(page).to have_select("user_birthday_1i", selected: new_attrs.birthday.strftime("%Y"))
    expect(page).to have_select("user_birthday_2i", selected: new_attrs.birthday.strftime("%B"))
    expect(page).to have_select("user_birthday_3i", selected: new_attrs.birthday.strftime("%e"))
  end

  def fill_in_password(password)
    fill_in(
      "Password (leave blank if you don't want to change it)",
      with: password,
    )
    fill_in("Password confirmation", with: password)
  end
end
