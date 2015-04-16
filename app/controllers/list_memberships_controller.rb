class ListMembershipsController < ApplicationController
  def create
    find_list.add_user(find_user)
    redirect_to profile_path(find_user)
  end

  private

  def find_user
    @find_user ||= User.find(params[:profile_id])
  end

  def find_list
    InfluencerList.find(params[:list_membership][:influencer_list])
  end
end
