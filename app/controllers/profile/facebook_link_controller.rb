class Profile::FacebookLinkController < ApplicationController
  def destroy
    if current_user.update(facebook_token: nil)
      Rails.cache.delete("facebook_client_#{current_user.id}")
      redirect_to profile_social_path
    else
      current_user.reload
      flash[:alert] = 'Error removing Facebook. Please try again later.'
      render 'profile/social_profiles_connection/show'
    end
  end
end
