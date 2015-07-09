require 'rails_helper'

describe InstagramAdapter do
  let(:access_token) { 42 }
  let(:user) { build_stubbed :user, instagram_token: access_token }
  let(:client) { double }

  subject { InstagramAdapter.from_user(user) }

  before { Rails.cache.clear }

  describe '#follower_count' do
    context 'with valid access token' do
      before do
        expect(Instagram)
          .to receive(:client)
          .with(access_token: access_token)
          .and_return client
      end

      it 'calls the appropriate method from the Instagram gem' do
        expect(client).to receive_message_chain(:user, :counts, :followed_by)
        subject.follower_count
      end
    end

    context 'with invalid access token' do
      before do
        expect(Instagram)
          .to receive(:client)
          .with(access_token: access_token)
          .and_raise Instagram::BadRequest
      end

      it 'updates the user and removes their token' do
        expect_any_instance_of(User)
          .to receive(:update)
          .with(instagram_token: nil)
        expect(subject.follower_count).to eq false
      end
    end
  end

  describe '#media' do
    context 'with valid access token' do
      before do
        expect(Instagram)
          .to receive(:client)
          .with(access_token: access_token)
          .and_return client
      end

      it 'calls the appropriate method from the Instagram gem' do
        expect(client).to receive(:user_recent_media)
        subject.media
      end
    end

    context 'with invalid access token' do
      before do
        expect(Instagram)
          .to receive(:client)
          .with(access_token: access_token)
          .and_raise Instagram::BadRequest
      end

      it 'updates the user and removes their token' do
        expect_any_instance_of(User)
          .to receive(:update)
          .with(instagram_token: nil)
        expect(subject.media).to eq false
      end
    end
  end
end
