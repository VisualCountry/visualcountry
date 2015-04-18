require "rails_helper"

describe TwitterAuthenticator do
  describe "#authenticate" do
    it "updates the credentials on a provided user and returns it" do
      user = create(:user)
      auth_data = {
        "uid" => "my-uid",
        "credentials" => {
          "token" => "my-token",
          "secret" => "my-secret",
        },

      }
      authenticator = TwitterAuthenticator.new(user, auth_data)

      updated_user = authenticator.authenticate

      expect(updated_user.id).to eq user.id
      expect(updated_user.twitter_uid).to eq "my-uid"
      expect(updated_user.twitter_token).to eq "my-token"
      expect(updated_user.twitter_token_secret).to eq "my-secret"
    end

    it "finds, updates, and returns an existing user if one isn't provided" do
      user = create(:user, twitter_uid: "my-uid")
      auth_data = {
        "uid" => user.twitter_uid,
        "credentials" => {
          "token" => "my-new-token",
          "secret" => "my-new-secret",
        },

      }
      authenticator = TwitterAuthenticator.new(nil, auth_data)

      updated_user = authenticator.authenticate

      expect(updated_user.id).to eq user.id
      expect(updated_user.twitter_uid).to eq user.twitter_uid
      expect(updated_user.twitter_token).to eq "my-new-token"
      expect(updated_user.twitter_token_secret).to eq "my-new-secret"
    end

    it "returns nil if it can't find a user" do
      authenticator = TwitterAuthenticator.new(nil, {})

      expect(authenticator.authenticate).to eq nil
    end
  end

  describe "#credentials" do
    it "returns a formatted hash of authentication credentials" do
      auth_data = {
        "info" => {
          "name" => "my-name",
        },
        "uid" => "my-uid",
        "credentials" => {
          "token" => "my-token",
          "secret" => "my-secret",
        },
      }
      authenticator = TwitterAuthenticator.new(nil, auth_data)

      expect(authenticator.credentials).to eq({
        name: "my-name",
        uid: "my-uid",
        access_token: "my-token",
        token_secret: "my-secret",
      })
    end
  end
end
