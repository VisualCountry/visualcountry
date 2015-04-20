class InfluencerListsController < ApplicationController
  before_action :authorize_admin!, except: [:show]

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

  def edit
    @influencer_list = find_influencer_list
  end

  def update
    @influencer_list = find_influencer_list

    if @influencer_list.update(influencer_list_params)
      redirect_to @influencer_list
    else
      render :edit
    end
  end

  def show
    @influencer_list = find_influencer_list
  end

  def index
    @influencer_lists = current_user.influencer_lists
  end

  def destroy
    list = find_influencer_list
    list.destroy
    redirect_to influencer_lists_path, alert: "\"#{list.name}\" deleted!"
  end

  private

  def find_influencer_list
    InfluencerList.find_by(uuid: params[:id])
  end

  def influencer_list_params
    params.
      require(:influencer_list).
      permit(:name).
      merge(owner: current_user)
  end
end
