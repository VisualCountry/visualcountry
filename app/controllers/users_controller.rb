class UsersController < ApplicationController
  before_action :set_user

  def show
    if current_user.admin?
      @available_lists = InfluencerList.all - @user.lists_member_of
      @available_organizations = Organization.all - @user.organizations
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
