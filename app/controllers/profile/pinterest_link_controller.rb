class Profile::PinterestLinkController < ApplicationController
  def destroy
    current_user.pinterest_token = nil
    current_user.save!
    redirect_to profile_social_path
  end
end
