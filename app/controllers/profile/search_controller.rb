class Profile::SearchController < ApplicationController
  def index
    @profiles = User.search(search_params)
  end

  def new
  end

  private

  def search_params
    params.
      require(:search).
      permit(
        :focuses,
        :interests,
        :max_followers,
        :min_followers,
        :near,
        :query,
        :social_profiles,
      )
  end
end
