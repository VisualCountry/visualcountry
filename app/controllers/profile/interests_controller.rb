class Profile::InterestsController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update(interest_params)
      redirect_to profile_interests_path, notice: "Successfully Updated Interests"
    else
      render :edit
    end
  end

  private

  def interest_params
    params.require(:user).permit(:special_interests, interest_ids: [])
  end
end
