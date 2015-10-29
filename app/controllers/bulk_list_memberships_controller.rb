class BulkListMembershipsController < ApplicationController
  def create
    list = find_list
    list.add_profiles(find_profiles)
    redirect_to list
  end

  private

  def find_list
    InfluencerList.find(bulk_params[:influencer_list])
  end

  def find_profiles
    Profile.find(bulk_params[:profile_ids])
  end

  def bulk_params
    params.
      require(:bulk_list_membership).
      permit(
        :influencer_list,
        profile_ids: [],
      )
  end
end
