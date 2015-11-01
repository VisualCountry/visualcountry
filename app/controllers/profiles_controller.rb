class ProfilesController < ApplicationController
  before_action :set_profile
  before_action :set_instagram_feed
  before_action :set_vine_feed

  def show
    if current_user.admin?
      @available_lists = InfluencerList.all - @profile.lists_member_of
      @available_organizations = Organization.all - @profile.organizations
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def set_instagram_feed
    return unless user = @profile.user
    @instagram_feed = InstagramAdapter.from_user(user).media
  end

  def set_vine_feed
    return unless user = @profile.user
    @vine_feed = VineAdapter.from_user(user).media
  end
end
