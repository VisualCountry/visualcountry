class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth_data = request.env['omniauth.auth']
    current_user.facebook_token = auth_data['credentials']['token']
    current_user.save!
    redirect_to profile_social_path
  end

  def instagram
    auth_data = request.env['omniauth.auth']
    current_user.instagram_token = auth_data['credentials']['token']
    current_user.save!
    redirect_to profile_social_path
  end

  def twitter
    auth_data = request.env['omniauth.auth']
    current_user.twitter_token = auth_data['credentials']['token']
    current_user.twitter_token_secret = auth_data['credentials']['secret']
    current_user.save!
    redirect_to profile_social_path
  end

  def Pinterest
    auth_data = request.env['omniauth.auth']
    current_user.pinterest_token = auth_data['credentials']['token']
    current_user.save!
    redirect_to profile_social_path
  end
end
