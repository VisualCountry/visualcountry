class ListMembershipsController < ApplicationController
  def create
    user = find_user
    find_list.add_user(user)
    redirect_to profile_path(user)
  end

  def destroy
    membership = find_membership
    membership.destroy
    redirect_to influencer_list_path(membership.influencer_list)
  end

  private

  def find_user
    User.find(list_membership_params[:profile_id])
  end

  def find_list
    InfluencerList.find(list_membership_params[:influencer_list_id])
  end

  def find_membership
    ListMembership.find(params[:id])
  end

  def list_membership_params
    params.
      require(:list_membership).
      permit(
        :influencer_list_id,
        :profile_id,
      )
  end
end
