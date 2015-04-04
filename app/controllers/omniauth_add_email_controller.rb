class OmniauthAddEmailController < ApplicationController
  def new
  end

  def create
    if user = User.find_by(email: params[:email][:email])
      if user.update_without_password(
        twitter_token: session[:omniauth_data]['access_token'],
        twitter_token_secret: session[:omniauth_data]['token_secret'],
      )
        sign_in(user)
        redirect_to profile_social_path
      else
        redirect_to root_path, alert: 'Unable to sign into Twitter'
      end
    else
      if user = User.create(
        name: session[:omniauth_data]['name'],
        email: params[:email][:email],
        password: Devise.friendly_token,
        twitter_uid: session[:omniauth_data]['uid'],
        twitter_token: session[:omniauth_data]['access_token'],
        twitter_token_secret: session[:omniauth_data]['token_secret'],
      )
        sign_in(user)
        redirect_to profile_social_path
      else
        redirect_to root_path, alert: 'Unable to sign into Twitter'
      end
    end
  end
end
