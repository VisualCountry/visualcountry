require "rails_helper"

describe User do
  it { is_expected.to have_many(:influencer_lists).dependent(:destroy) }

  describe '#owns_list?' do
    it "returns true if the user's the owner of the influencer list" do
      user = create(:user)
      list = create(:influencer_list, owner: user)

      expect(user.owns_list?(list)).to eq true
    end

    it "returns false if the user's not the owner of the influencer list" do
      user = create(:user)
      list = create(:influencer_list)

      expect(user.owns_list?(list)).to eq false
    end
  end

  describe '#can_manage_list' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }
    let(:list) { create(:influencer_list) }

    before do
      user.reload
      organization.add_profile(user.profile)
    end

    context 'when the user is a member of an organization the list belongs to' do
      before { organization.add_list(list) }
      specify { expect(user.can_manage_list?(list)).to eq true }
    end

    context 'when the user is not a member of an organization the list belogns to' do
      specify { expect(user.can_manage_list?(list)).to eq false }
    end
  end
end
