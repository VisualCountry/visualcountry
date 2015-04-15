require "rails_helper"

describe ListMembership do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :influencer_list }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:influencer_list_id) }
end
