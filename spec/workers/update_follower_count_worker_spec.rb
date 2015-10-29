require 'rails_helper'

describe UpdateFollowerCountWorker do
  let(:profile) { create :profile }
  let(:follower_count) { 1_000_000 }
  let(:platform_name) { :facebook }
  let(:platform) { double(follower_count: follower_count) }
  let(:update_follower_count) { double(perform: true) }

  subject(:worker) do
    UpdateFollowerCountWorker.new.perform(profile.id, platform_name)
  end

  describe '#perform' do
    it 'enqueues a job to update the follower count of a profile and platform' do
      allow(UpdateFollowerCount)
        .to receive(:new)
        .with(profile.id, platform_name)
        .and_return update_follower_count

      expect(update_follower_count).to receive(:perform)

      worker
    end
  end
end
