class Profile::InterestsController < ApplicationController
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
    params.require(:user).permit(interest_ids: [])
  end
end
