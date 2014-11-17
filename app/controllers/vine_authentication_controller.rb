class VineAuthenticationController < ApplicationController
  def new
   
  end

  def create
    current_user.vine_email = params[:vine][:email]
    current_user.vine_password = params[:vine][:password]
    current_user.save
    redirect_to connect_profiles_path
  end

   def destroy
    current_user.vine_email = nil
    current_user.vine_password = nil
    current_user.save
    redirect_to connect_profiles_path
  end
end
