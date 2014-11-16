class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth_data = request.env['omniauth.auth']
    current_user.facebook_token = auth_data['credentials']['token']
    current_user.save!
    redirect_to connect_profiles_path
  end

  def instagram
    auth_data = request.env['omniauth.auth']
    current_user.instagram_token = auth_data['credentials']['token']
    current_user.save!
    redirect_to connect_profiles_path
  end
end