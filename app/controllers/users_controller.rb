class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @available_lists = current_user.lists_without(@user) if current_user
  end
end
