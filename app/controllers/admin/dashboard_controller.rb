class Admin::DashboardController < ApplicationController
  before_action :authorize_admin!
  layout "application_with_sidebar"

  def index
  end
end
