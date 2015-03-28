class Profile::SearchController < ApplicationController
  def index
    @profiles = User.search(
      name: params[:search][:query],
      interests: params[:search][:interests],
      social_profiles: params[:search][:social_profiles],
      min_followers: params[:search][:min_followers],
      max_followers: params[:search][:max_followers],
      focuses: params[:search][:focuses],
    )
  end

  def new
  end
end
