require "rails_helper"

describe InstagramAuthenticator do
  it "updates the user's instagram token" do
    user = create(:user)
    auth_data = {
      "credentials" => {
        "token" => "my-instagram-token",
      },
    }

    InstagramAuthenticator.new(user, auth_data).authenticate

    user.reload
    expect(user.instagram_token).to eq "my-instagram-token"
  end
end
