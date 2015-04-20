require "rails_helper"

feature "admins can share lists" do
  scenario "anyone (even without an account) can see a list if they know the URL" do
    list = create(:influencer_list)

    visit influencer_list_path(list)

    within ".list-name" do
      expect(page).to have_content list.name
    end
  end
end
