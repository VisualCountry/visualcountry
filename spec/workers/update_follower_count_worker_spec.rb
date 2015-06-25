require 'rails_helper'

describe UpdateFollowerCountWorker do
  let(:user) { create :user }
  let(:follower_count) { 1_000_000 }
  let(:platform_name) { :facebook }
  let(:platform) { double(follower_count: follower_count) }
  let(:follower_count_attribute) { "cached_#{platform_name}_follower_count" }

  subject(:worker) do
    UpdateFollowerCountWorker.new.perform(user.id, platform_name)
  end

  describe '#perform' do
    it 'enqueues a job to update the follower count of a user and platform' do
      expect_any_instance_of(User).to receive(platform_name).and_return platform
      expect_any_instance_of(User)
        .to receive(:update)
        .with({follower_count_attribute => follower_count})

      worker
    end
  end
end
