class Profile::FacebookLinkController < ApplicationController
  def destroy
    current_user.facebook_token = nil
    current_user.save!
    redirect_to profile_social_path
  end
end
