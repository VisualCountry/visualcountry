class Profile::InterestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  layout 'application_with_sidebar'

  def edit
  end

  def update
    if @profile.update(interest_params)
      redirect_to profile_interests_path, notice: "Successfully Updated Interests"
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def interest_params
    params.require(:profile).permit(:special_interests, interest_ids: [])
  end
end
