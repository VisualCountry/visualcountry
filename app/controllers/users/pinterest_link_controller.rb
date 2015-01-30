class Users::PinterestLinkController < ApplicationController
  def destroy
    current_user.pinterest_token = nil
    current_user.save!
    redirect_to users_social_path
  end
end
