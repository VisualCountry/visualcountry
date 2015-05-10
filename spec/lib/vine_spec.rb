require 'rails_helper'

describe Vine do
  describe 'unit tests' do
    let(:token) { double }
    let(:email) { double }
    let(:password) { double }
    let(:fetched_user_id) { double }
    let(:fetched_token) { double }
    let(:follower_count) { double }
    let(:payload) { {username: email, password: password} }
    let(:token_data) do
      { 'key' => fetched_token }
    end
    let(:user_data) do
      {
        'userId' => fetched_user_id,
        'followerCount' => follower_count
       }
    end

    before :each do
      allow_any_instance_of(Vine)
        .to receive(:post)
        .with("#{Vine::VINE_BASE_URL}/users/authenticate", payload)
        .and_return(token_data)

      allow_any_instance_of(Vine)
        .to receive(:get)
        .with("#{Vine::VINE_BASE_URL}/users/me")
        .and_return(user_data)
    end

    subject { Vine.new(token, email, password) }

    describe '.new' do
      context 'when token is passed' do
        let(:email) { nil }
        let(:password) { nil }

        before :each do
          expect_any_instance_of(Vine)
            .to receive(:get)
            .with("#{Vine::VINE_BASE_URL}/users/me")
            .and_return(user_data)
        end

        it 'returns a Vine object' do
          expect(subject).to be_a Vine
        end
      end

      context 'when email and password is passed' do
        let(:token) { nil }

        before :each do
          expect_any_instance_of(Vine)
            .to receive(:post)
            .with("#{Vine::VINE_BASE_URL}/users/authenticate", payload)
            .and_return(token_data)

          expect_any_instance_of(Vine)
            .to receive(:get)
            .with("#{Vine::VINE_BASE_URL}/users/me")
            .and_return(user_data)
        end

        it 'returns a Vine object' do
          expect(subject).to be_a Vine
        end

        it 'has a token' do
          expect(subject.token).to eq fetched_token
        end
      end
    end

    describe '.from_auth' do
      subject { Vine.from_auth(email, password) }

      context 'when valid' do
        it 'it returns a new Vine object' do
          expect(subject).to be_a Vine
        end
      end

      context 'when invalid' do
        let(:fetched_token) { nil }

        it 'returns false' do
          expect(subject).to eq false
        end
      end
    end

    describe '#media' do
      let(:timeline_data) do
        { 'records' => timeline_records }
      end
      let(:timeline_records) do
        [{ 'foo' => 'bar'}]
      end

      before :each do
        expect(subject)
          .to receive(:get)
          .with("#{Vine::VINE_BASE_URL}/timelines/users/#{fetched_user_id}")
          .and_return(timeline_data)
      end

      it 'returns the same number of Vine::Video objects as returned by the API' do
        expect(subject.media.count).to eq timeline_records.count
      end

      it 'returns Vine::Video objects' do
        all_videos = subject.media.all? { |m| m.is_a? Vine::Video }
        expect(all_videos).to eq true
      end
    end

    describe '#user' do
      it 'returns a Vine::User object' do
        expect(subject.user.followerCount).to eq follower_count
      end
    end

    describe '#valid' do
      context 'with token' do
        it 'returns true' do
          expect(subject.valid?).to eq true
        end
      end

      context 'without a token' do
        let(:token) { nil }
        let(:fetched_token) { nil }

        it 'returns false' do
          expect(subject.valid?).to eq false
        end
      end
    end
  end

  describe 'integration tests', vcr: true do
    let(:token) { '919828132675067904-c34cd3a8-a39f-45da-87c5-0a2442a58b48' }

    it 'fetches Vine videos' do
      vine_client = Vine.new(token)
      first_vine_video = vine_client.media.first
      expect(first_vine_video.shareUrl).to eq 'https://vine.co/v/ezHD6XuIAU0'
      expect(first_vine_video.description).to eq 'Golfing in Nyc.'
    end
  end
end