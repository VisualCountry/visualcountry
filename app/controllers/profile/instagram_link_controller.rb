class Profile::InstagramLinkController < ApplicationController
  def destroy
    current_user.instagram_token = nil
    current_user.save!
    redirect_to profile_social_path
  end
end
