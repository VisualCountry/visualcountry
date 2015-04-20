class ListCopiesController < ApplicationController
  def create
    new_list = ListCopier.new(find_list).copy
    if new_list.save
      redirect_to influencer_list_path(new_list)
    else
      redirect_to(
        influencer_list_path(find_list),
        alert: "Can't copy this list. Perhaps the name \"#{new_list.name}\" has already been taken?",
      )
    end
  end

  private

  def find_list
    @find_list ||= InfluencerList.find(params[:list_copy][:id])
  end
end
