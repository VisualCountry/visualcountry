class ProfilesController < ApplicationController
  def show
    @profile = Profile.find(params[:id])
    @instagram_feed = InstagramAdapter.from_user(@profile.user).media
    @vine_feed = VineAdapter.from_user(@profile.user).media

    if current_user.admin?
      @available_lists = InfluencerList.all - @profile.lists_member_of
      @available_organizations = Organization.all - @profile.organizations
    end
  end
end
