class Profile::SearchController < ApplicationController
  before_action :authorize_admin!

  layout 'application_with_sidebar'

  def index
    @profiles = ProfileSearchQuery.new(search_params).search
  end

  def new
    @interests = Interest.all
    @social_platforms = %w(vine twitter instagram facebook pinterest)
    @focuses = Focus.all
    @genders = Profile.genders.keys
    @ethnicities = Profile.ethnicities.keys
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
        :ethnicity,
        :min_age,
        :max_age,
        gender: [],
        social_profiles: [],
        focuses: [],
        interests: [],
      )
  end
end
