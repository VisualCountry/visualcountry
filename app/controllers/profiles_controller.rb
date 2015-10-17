class ProfilesController < ApplicationController
  def show
    @profile = Profile.find(params[:id])
    @instagram_feed = InstagramAdapter.from_user(@profile.user).media
    @vine_feed = VineAdapter.from_user(@profile.user).media
  end
end
