class UsersController < ApplicationController
  def show
    @user = find_user
    if current_user.admin?
      @available_lists = current_user.lists_without(@user)
      @available_organizations = Organization.all
    end
  end

  private

  def find_user
    User.find(params[:id])
  end
end
