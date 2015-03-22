class Profile::SocialProfilesConnectionController < ApplicationController
  before_action :authenticate_user!
  before_action :warm_follower_count_cache

  def show
  end

  private

  def warm_follower_count_cache
    current_user.warm_follower_count_cache
  end
end
