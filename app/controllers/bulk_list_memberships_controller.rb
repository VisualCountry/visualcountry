class BulkListMembershipsController < ApplicationController
  def create
    list = find_list
    list.add_users(find_users)
    redirect_to list
  end

  private

  def find_list
    InfluencerList.find(bulk_params[:influencer_list])
  end

  def find_users
    User.find(bulk_params[:user_ids])
  end

  def bulk_params
    params.
      require(:bulk_list_membership).
      permit(
        :influencer_list,
        user_ids: [],
      )
  end
end
