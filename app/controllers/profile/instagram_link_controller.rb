class Profile::InstagramLinkController < ApplicationController
  def destroy
    if current_user.update(instagram_token: nil, cached_instagram_follower_count: nil)
      Rails.cache.delete("instagram-media-#{current_user.instagram_token}")
      redirect_to profile_social_path
    else
      current_user.reload
      flash[:alert] = 'Error removing Instagram. Please try again later.'
      render 'profile/social_profiles_connection/show'
    end
  end
end
