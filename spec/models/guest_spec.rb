require "rails_helper"

describe Guest do
  it "doesn't have an account" do
    expect(Guest.new).not_to have_account
  end

  it "isn't an admin" do
    expect(Guest.new).not_to be_admin
  end

  it "doesn't own any lists" do
    list = create(:influencer_list)

    expect(Guest.new.owns_list?(list)).to eq false
  end
end
