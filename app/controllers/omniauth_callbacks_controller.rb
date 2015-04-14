class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    user = FacebookAuthenticator.new(auth_data).authenticate

    if user
      sign_in(user)
      redirect_to profile_social_path
    else
      redirect_to root_path, alert: "Unable to sign into Facebook"
    end
  end

  def twitter
    authenticator = TwitterAuthenticator.new(current_user, auth_data)
    user = authenticator.authenticate

    if user
      sign_in(user)
      redirect_to profile_social_path
    else
      session[:omniauth_data] = authenticator.credentials
      redirect_to new_omniauth_add_email_path
    end
  end

  def instagram
    InstagramAuthenticator.new(current_user, auth_data).authenticate
    redirect_to profile_social_path
  end

  def pinterest
    PinterestAuthenticator.new(current_user, auth_data).authenticate
    redirect_to profile_social_path
  end

  private

  def auth_data
    request.env["omniauth.auth"]
  end
end
