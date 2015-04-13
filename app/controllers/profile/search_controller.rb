class Profile::SearchController < ApplicationController
  def index
    @profiles = ProfileSearchQuery.new(search_params).search
  end

  def new
  end

  private

  def search_params
    params.
      require(:search).
      permit(
        :max_followers,
        :min_followers,
        :near,
        :query,
        :gender,
        :ethnicity,
        :min_age,
        :max_age,
        social_profiles: [],
        focuses: [],
        interests: [],
      )
  end
end
