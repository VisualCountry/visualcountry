class UsersController < ApplicationController
  def show
    @user = find_user
    if current_user.admin?
      @available_lists = InfluencerList.all - current_user.lists_member_of
      @available_organizations = Organization.all - @user.organizations
    end
  end

  private

  def find_user
    User.find(params[:id])
  end
end
