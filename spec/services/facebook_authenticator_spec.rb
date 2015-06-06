require "rails_helper"

describe FacebookAuthenticator do
  let(:uid) { '42' }
  let(:email) { 'pickle.lee@gmail.com' }
  let(:name) { 'Pickle Lee' }
  let(:token) { 'kittens' }
  let(:expires_at) { 1.week.from_now }
  let(:gender) { 'Female' }
  let(:auth_data) do
    {
      "uid" => uid,
      "info" => {
        "email" => email,
      },
      "credentials" => {
        "token" => token,
        "expires_at" => expires_at,
      },
      "extra" => {
        "raw_info" => {
          "name" => name,
          "gender" => gender,
        },
      },
    }
  end

  context 'user is already signed in' do
    let!(:user) { create :user, email: email, name: name, gender: gender }

    subject { FacebookAuthenticator.from_current_user(user, auth_data) }

    it 'finds and updates the Facebook attributes on User' do
      subject
      expect(user.facebook_uid).to eq uid
      expect(user.facebook_token).to eq token
      expect(user.facebook_token_expiration).to eq Time.at(expires_at)
    end

    it 'does not create a new user' do
      expect { subject }.to_not change { User.count }
    end
  end

  context 'new user' do
    subject { FacebookAuthenticator.from_facebook_login(auth_data) }

    it 'creates a new user' do
      expect { subject }.to change { User.count }.by(1)
    end

    it 'sets the user data appropriately' do
      updated_user = subject

      expect(updated_user.email).to eq email
      expect(updated_user.name).to eq name
      expect(updated_user.gender).to eq gender
      expect(updated_user.facebook_uid).to eq uid
      expect(updated_user.facebook_token).to eq token
      expect(updated_user.facebook_token_expiration).to eq Time.at(expires_at)
    end
  end
end
