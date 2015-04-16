class BulkListMembershipsController < ApplicationController
  def create
    find_users.each do |user|
      find_list.add_user(user)
    end

    redirect_to find_list
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
