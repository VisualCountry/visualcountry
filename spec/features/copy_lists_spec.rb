require "rails_helper"

feature "admins can create copies of their lists" do
  scenario "create copy" do
    admin = create(:admin)
    user = create(:user)
    list = create(:influencer_list, owner: admin, users: [user])
    login_as(admin)

    visit influencer_list_path(list)
    click_on "Copy List"

    within ".list-name" do
      expect(page).to have_content "#{list.name} (copy)"
    end
    expect(page).to have_content user.name
  end
end
