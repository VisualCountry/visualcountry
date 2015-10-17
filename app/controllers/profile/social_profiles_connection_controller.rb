class Profile::SocialProfilesConnectionController < ApplicationController
  before_action :authenticate_user!

  layout :application_with_sidebar

  def show
    @profile = current_user.profile
  end
end
