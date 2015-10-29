class Profile::VineController < ApplicationController
  def new
  end

  def create
    vine_email = params[:vine][:email]
    vine_password = params[:vine][:password]
    vine_client = Vine.from_auth(vine_email, vine_password)

    if vine_client
      current_user.update(
        vine_email: vine_email,
        vine_password: vine_password,
        vine_token: vine_client.token
      )

      redirect_to profile_social_path
    else
      flash[:alert] = 'Invalid Email or Password'
      render :new
    end
  end

   def destroy
    current_user.update(vine_email: nil, vine_password: nil, vine_token: nil)
    current_user.profile.update(vine_follower_count: nil)
    Rails.cache.delete("vine-media-#{current_user.vine_token}")
    redirect_to profile_social_path
  end
end
