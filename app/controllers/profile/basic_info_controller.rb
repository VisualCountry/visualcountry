class Profile::BasicInfoController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  layout 'application_with_sidebar'

  def edit
  end

  def update
    if @profile.update(basic_info_params)
      redirect_to profile_basic_info_path, notice: "Successfully updated basic info"
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def basic_info_params
    params.require(:profile).permit(
      :bio,
      :name,
      :city,
      :website,
      :picture,
      'birthday(1i)',
      'birthday(2i)',
      'birthday(3i)',
      :ethnicity,
      :gender,
    ).merge(
     focus_ids: focus_ids
    )
  end

  def focus_ids
    return unless focus_token_params
    focus_token_params[:focus_tokens].split(',')
  end

  def focus_token_params
    params.require(:profile).permit(:focus_tokens)
  end
end
