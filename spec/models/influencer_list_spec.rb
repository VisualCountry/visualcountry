require "rails_helper"

describe InfluencerList do
  it { is_expected.to belong_to :owner }
  it { is_expected.to have_many(:list_memberships).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:list_memberships) }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }
end
