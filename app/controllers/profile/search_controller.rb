class Profile::SearchController < ApplicationController
  def index
    @profiles = ProfileSearchQuery.new.search(search_params)
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
        :gender,
        :ethnicity,
        :social_profiles,
      )
  end
end
