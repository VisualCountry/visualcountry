require "rails_helper"

describe ListMembership do
  it { is_expected.to belong_to :profile }
  it { is_expected.to belong_to :influencer_list }
  it { is_expected.to validate_uniqueness_of(:profile_id).scoped_to(:influencer_list_id) }
end
