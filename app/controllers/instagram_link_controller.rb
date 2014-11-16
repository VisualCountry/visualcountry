class InstagramLinkController < ApplicationController
  def destroy
    current_user.instagram_token = nil
    current_user.save!
    redirect_to connect_profiles_path
  end
end
