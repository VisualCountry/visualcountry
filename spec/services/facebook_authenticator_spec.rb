require "rails_helper"

describe FacebookAuthenticator do
  describe "#authenticate" do
    it "finds, updates, and returns an existing user if one exists" do
      user = create(:user)
      expiration = 1.week.from_now
      auth_data = {
        "info" => {
          "email" => user.email,
        },
        "credentials" => {
          "token" => "my-new-token",
          "expires_at" => expiration,
        },
      }
      authenticator = FacebookAuthenticator.new(auth_data)

      updated_user = authenticator.authenticate

      expect(updated_user.id).to eq user.id
      expect(updated_user.facebook_token).to eq "my-new-token"
      expect(updated_user.facebook_token_expiration).to eq Time.at(expiration)
    end

    it "creates and authenticates a new user if one doesn't exist" do
      user = build(:user)
      expiration = 1.week.from_now
      auth_data = {
        "info" => {
          "email" => user.email,
        },
        "credentials" => {
          "token" => "my-new-token",
          "expires_at" => expiration,
        },
        "extra" => {
          "raw_info" => {
            "name" => user.name,
          },
        },
      }
      authenticator = FacebookAuthenticator.new(auth_data)

      updated_user = authenticator.authenticate

      expect(updated_user.email).to eq user.email
      expect(updated_user.name).to eq user.name
      expect(updated_user.gender).to eq user.gender
      expect(updated_user.facebook_token).to eq "my-new-token"
      expect(updated_user.facebook_token_expiration).to eq Time.at(expiration)
    end
  end
end
