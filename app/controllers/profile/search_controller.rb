class Profile::SearchController < ApplicationController
  def index
    @profiles = User.search(
      name: params[:search][:query],
      interests: params[:search][:interests]
    )
  end

  def new
  end
end
