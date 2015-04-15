class InfluencerListsController < ApplicationController
  before_action :authorize_admin!

  def new
    @influencer_list = InfluencerList.new
  end

  def create
    @influencer_list = InfluencerList.new(influencer_list_params)

    if @influencer_list.save
      redirect_to @influencer_list
    else
      render :new
    end
  end

  def show
    @influencer_list = find_influencer_list
  end

  def index
    @influencer_lists = current_user.influencer_lists
  end

  private

  def find_influencer_list
    InfluencerList.find(params[:id])
  end

  def influencer_list_params
    params.
      require(:influencer_list).
      permit(:name).
      merge(owner: current_user)
  end
end
