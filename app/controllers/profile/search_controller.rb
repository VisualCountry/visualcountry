class Profile::SearchController < ApplicationController
  def index
    @profiles = User.search(
      name: params[:search][:query],
      interests: params[:search][:interests],
      social_profiles: params[:search][:social_profiles]
    )
  end

  def new
  end
end
