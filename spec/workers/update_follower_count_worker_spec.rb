require 'rails_helper'

describe UpdateFollowerCountWorker do
  let(:user) { create :user }
  let(:follower_count) { 1_000_000 }
  let(:platform_name) { :facebook }
  let(:platform) { double(follower_count: follower_count) }
  let(:follower_count_attribute) { "cached_#{platform_name}_follower_count" }
  let(:update_follower_count) { double(perform: true) }

  subject(:worker) do
    UpdateFollowerCountWorker.new.perform(user.id, platform_name)
  end

  describe '#perform' do
    it 'enqueues a job to update the follower count of a user and platform' do
      allow(UpdateFollowerCount)
        .to receive(:new)
        .with(user.id, platform_name)
        .and_return update_follower_count

      expect(update_follower_count).to receive(:perform)

      worker
    end
  end
end
