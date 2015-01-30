class Users::InstagramLinkController < ApplicationController
  def destroy
    current_user.instagram_token = nil
    current_user.save!
    redirect_to users_social_path
  end
end
