class Admin::DashboardController < ApplicationController
  before_action :authorize_admin!
  layout 'application_with_sidebar'

  def index
    @users = Profile.all.order(created_at: :desc).page(params[:page])
  end
end
