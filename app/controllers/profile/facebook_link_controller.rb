class Profile::FacebookLinkController < ApplicationController
  def destroy
    if current_user.update(facebook_token: nil, facebook_uid: nil)
      current_user.profile.update(facebook_follower_count: nil)
      redirect_to profile_social_path
    else
      current_user.reload
      flash[:alert] = 'Error removing Facebook. Please try again later.'
      render 'profile/social_profiles_connection/show'
    end
  end
end
