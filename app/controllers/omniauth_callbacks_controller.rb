class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth_data = request.env['omniauth.auth']

    if user = User.find_by(email: auth_data['info']['email'])
      if user.update_without_password(
        facebook_token: auth_data['credentials']['token'],
        facebook_token_expiration: Time.at(auth_data['credentials']['expires_at']),
      )
        sign_in(user)
        redirect_to profile_social_path
      else
        redirect_to root_path, alert: 'Unable to sign into Facebook'
      end
    else
      if user = User.create(
        name: auth_data['extra']['raw_info']['name'],
        email: auth_data['info']['email'],
        password: Devise.friendly_token,
        gender: User.genders[auth_data['extra']['raw_info']['name']],
        facebook_token: auth_data['credentials']['token'],
        facebook_token_expiration: Time.at(auth_data['credentials']['expires_at']),
      )
        sign_in user
        redirect_to profile_social_path
      else
        redirect_to root_path, alert: 'Unable to sign into Facebook, try adding an email to your facebook account'
      end
    end
  end

  def twitter
    auth_data = request.env['omniauth.auth']

    if current_user
      current_user.update(
        twitter_uid: auth_data['uid'],
        twitter_token: auth_data['credentials']['token'],
        twitter_token_secret: auth_data['credentials']['secret'],
      )
      redirect_to profile_social_path
    elsif user = User.find_by(twitter_uid: auth_data['uid'])
      user.update(
        twitter_uid: auth_data['uid'],
        twitter_token: auth_data['credentials']['token'],
        twitter_token_secret: auth_data['credentials']['secret'],
      )
      sign_in user
      redirect_to profile_social_path
    else
      session[:omniauth_data] = {
        name: auth_data['info']['name'],
        uid: auth_data['uid'],
        access_token: auth_data['credentials']['token'],
        token_secret: auth_data['credentials']['secret'],
      }

      redirect_to new_omniauth_add_email_path
    end
  end

  def instagram
    auth_data = request.env['omniauth.auth']
    current_user.instagram_token = auth_data['credentials']['token']
    current_user.save!
    redirect_to profile_social_path
  end

  def pinterest
    auth_data = request.env['omniauth.auth']
    current_user.pinterest_token = auth_data['credentials']['token']
    current_user.save!
    redirect_to profile_social_path
  end
end
