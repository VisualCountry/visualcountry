class Profile::VineController < ApplicationController
  def new
  end

  def create
    current_user.vine_email = params[:vine][:email]
    current_user.vine_password = params[:vine][:password]
    current_user.save
    redirect_to profile_social_path
  end

   def destroy
    current_user.vine_email = nil
    current_user.vine_password = nil
    current_user.save
    redirect_to profile_social_path
  end
end
