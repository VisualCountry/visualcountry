class Profile::TwitterLinkController < ApplicationController
  def destroy
    if current_user.update(
      twitter_token: nil,
      twitter_token_secret: nil,
      cached_twitter_follower_count: nil,
      twitter_uid: nil)
      redirect_to profile_social_path
    else
      current_user.reload
      flash[:alert] = 'Error removing Twitter. Please try again later.'
      render 'profile/social_profiles_connection/show'
    end
  end
end
