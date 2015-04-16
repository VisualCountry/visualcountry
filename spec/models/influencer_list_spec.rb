require "rails_helper"

describe InfluencerList do
  it { is_expected.to belong_to :owner }
  it { is_expected.to have_many(:list_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:list_memberships) }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  describe "#add_user" do
    it "adds a user to the list" do
      list = create(:influencer_list)
      user = create(:user)

      list.add_user(user)

      expect(list.users).to include user
    end
  end

  describe "#remove_user" do
    it "removes a user from the list" do
      user = create(:user)
      list = create(:influencer_list, users: [user])

      list.remove_user(user)

      expect(list.users).not_to include user
    end
  end
end
