class Profile::TwitterLinkController < ApplicationController
  def destroy
    current_user.twitter_token = nil
    current_user.save!
    redirect_to profile_social_path
  end
end
