class Profile::PinterestLinkController < ApplicationController
  def destroy
    if current_user.update(pinterest_token: nil)
      Rails.cache.delete("pinterest_client_#{current_user.id}")
      redirect_to profile_social_path
    else
      current_user.reload
      flash[:alert] = 'Error removing Pinterest. Please try again later.'
      render 'profile/social_profiles_connection/show'
    end
  end
end
