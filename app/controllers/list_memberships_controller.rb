class ListMembershipsController < ApplicationController
  def create
    find_list.add_user(find_user)
    redirect_to profile_path(find_user)
  end

  def destroy
    find_list.remove_user(find_user)
    redirect_to influencer_list_path(find_list)
  end

  private

  def find_user
    @find_user ||= User.find(params[:profile_id])
  end

  def find_list
    @find_list ||= InfluencerList.find(influencer_list_id)
  end

  def influencer_list_id
    params[:influencer_list] || params[:list_membership][:influencer_list]
  end
end
