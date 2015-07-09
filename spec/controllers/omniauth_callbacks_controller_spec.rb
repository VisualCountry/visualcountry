require "rails_helper"

describe OmniauthCallbacksController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET facebook" do
    context 'user gave appropriate permissions' do
      let(:facebook_adapter) do
        double(permissions: [
          :user_friends, :user_posts, :read_stream, :email, :public_profile
        ])
      end

      before do
        expect(FacebookAdapter).to receive(:new).and_return facebook_adapter
      end

      it "we have a facebook user and can successfully update the token" do
        user = create(:user)

        request.env["omniauth.auth"] = {
          "info" => {
            "email" => user.email,
          },
          "credentials" => {
            "token" => "my-facebook-token",
            "expires_at" => 1.week.from_now,
          },
        }
        get :facebook

        expect(controller.current_user).to eq user
        expect(response).to redirect_to profile_social_path
      end

      it "we don't have a facebook user and can create one" do
        user = build(:user)

        request.env["omniauth.auth"] = {
          "info" => {
            "email" => user.email,
          },
          "extra" => {
            "raw_info" => {
              "name" => user.name,
            },
          },
          "credentials" => {
            "token" => "my-facebook-token",
            "expires_at" => 1.week.from_now,
          },
        }
        get :facebook

        expect(controller.current_user.email).to eq user.email
        expect(response).to redirect_to profile_social_path
      end
    end

    context 'user did not provide appropriate permissions' do
      let(:user) { build_stubbed :user }
      let(:facebook_adapter) { double(permissions: []) }

      before do
        expect(FacebookAdapter).to receive(:new).and_return facebook_adapter
      end

      it 'redirects to the homepage with an error' do
        request.env["omniauth.auth"] = {
          "info" => {
            "email" => user.email,
          },
          "extra" => {
            "raw_info" => {
              "name" => user.name,
            },
          },
          "credentials" => {
            "token" => "my-facebook-token",
            "expires_at" => 1.week.from_now,
          },
        }
        get :facebook

        expect(response).to redirect_to root_path
        expect(flash[:alert]).to include 'Whoops!'
      end
    end
  end

  describe "GET twitter" do
    it "logged-in users have their account associated with twitter" do
      user = create(:user)
      sign_in(user)

      request.env["omniauth.auth"] = {
        "uid" => "twitter-uid",
        "credentials" => {
          "token" => "my-twitter-token",
          "secret" => "my-twitter-secret",
        },
      }
      get :twitter

      user.reload
      expect(user.twitter_uid).to eq "twitter-uid"
      expect(user.twitter_token).to eq "my-twitter-token"
      expect(user.twitter_token_secret).to eq "my-twitter-secret"
      expect(controller.current_user).to eq user
      expect(response).to redirect_to profile_social_path
    end

    it "existing twitter-authenticated users have their tokens refreshed" do
      user = create(:user, twitter_uid: "twitter-uid")

      request.env["omniauth.auth"] = {
        "uid" => "twitter-uid",
        "credentials" => {
          "token" => "my-twitter-token",
          "secret" => "my-twitter-secret",
        },
      }
      get :twitter

      user.reload
      expect(user.twitter_token).to eq "my-twitter-token"
      expect(user.twitter_token_secret).to eq "my-twitter-secret"
      expect(controller.current_user).to eq user
      expect(response).to redirect_to profile_social_path
    end

    it "entirely new users are registered" do
      request.env["omniauth.auth"] = {
        "info" => {
          "name" => "My Name",
        },
        "uid" => "twitter-uid",
        "credentials" => {
          "token" => "my-twitter-token",
          "secret" => "my-twitter-secret",
        },
      }
      get :twitter

      expect(session[:omniauth_data]).to eq({
        name: "My Name",
        uid: "twitter-uid",
        access_token: "my-twitter-token",
        token_secret: "my-twitter-secret",
      })
      expect(response).to redirect_to new_omniauth_add_email_path
    end
  end

  describe "GET instagram" do
    it "updates the credentials of logged-in users" do
      user = create(:user)
      sign_in(user)

      request.env["omniauth.auth"] = {
        "credentials" => {
          "token" => "my-instagram-token",
        },
      }
      get :instagram

      user.reload
      expect(user.instagram_token).to eq "my-instagram-token"
      expect(response).to redirect_to profile_social_path
    end
  end

  describe "GET pinterest" do
    it "updates the credentials of logged-in users" do
      user = create(:user)
      sign_in(user)

      request.env["omniauth.auth"] = {
        "credentials" => {
          "token" => "my-pinterest-token",
        },
      }
      get :pinterest

      user.reload
      expect(user.pinterest_token).to eq "my-pinterest-token"
      expect(response).to redirect_to profile_social_path
    end
  end
end
