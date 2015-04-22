require "rails_helper"

describe InfluencerList do
  it { is_expected.to belong_to :owner }
  it { is_expected.to have_many(:list_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:list_memberships) }
  it { is_expected.to have_many(:organization_list_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:organizations) }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  describe "#add_user" do
    it "adds a user to the list" do
      list = create(:influencer_list)
      user = create(:user)

      list.add_user(user)

      expect(list.users).to include user
    end

    it "does nothing if the user is already on the list" do
      user = create(:user)
      list = create(:influencer_list, users: [user])

      list.add_user(user)

      expect(list.users).to include user
    end
  end

  describe "#add_users" do
    it "adds the users that aren't already on the list" do
      old_users = create_list(:user, 2)
      list = create(:influencer_list, users: old_users)
      new_user = create(:user)

      list.add_users([old_users.first, new_user])

      expect(list.users).to include new_user, *old_users
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

  describe "#organization_membership" do
    it "returns the membership between the list and the organization" do
      list = create(:influencer_list)
      organization = create(:organization)
      membership = create(
        :organization_list_membership,
        influencer_list: list,
        organization: organization,
      )

      expect(list.organization_membership(organization)).to eq membership
    end
  end
end
