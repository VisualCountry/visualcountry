class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    if current_user.admin?
      @available_lists = current_user.lists_without(@user)
    end
  end
end
