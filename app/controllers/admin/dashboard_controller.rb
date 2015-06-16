class Admin::DashboardController < ApplicationController
  before_action :authorize_admin!
  layout "application_with_sidebar"

  def index
    @users = User.all.by_created_at.page(params[:page])
  end
end
