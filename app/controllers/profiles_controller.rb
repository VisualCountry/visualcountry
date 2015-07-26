class ProfilesController < ApplicationController
  before_action :set_profile

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
end
