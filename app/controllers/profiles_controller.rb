class ProfilesController < ApplicationController

  def press 
  end

  def show
    @user = User.find(params[:id])
  end
end
