require "rails_helper"

describe PinterestAuthenticator do
  it "updates the user's pinterest token" do
    user = create(:user)
    auth_data = {
      "credentials" => {
        "token" => "my-pinterest-token",
      },
    }

    PinterestAuthenticator.new(user, auth_data).authenticate

    user.reload
    expect(user.pinterest_token).to eq "my-pinterest-token"
  end
end
