class Profile::TwitterLinkController < ApplicationController
  def destroy
    if current_user.update(twitter_token: nil, twitter_token_secret: nil)
       Rails.cache.delete("twitter-follower-count-#{current_user.id}")
      redirect_to profile_social_path
    else
      current_user.reload
      flash[:alert] = 'Error removing Twitter. Please try again later.'
      render 'profile/social_profiles_connection/show'
    end
  end
end
