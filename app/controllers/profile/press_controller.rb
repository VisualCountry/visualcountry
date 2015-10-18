class Profile::PressController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  layout 'application_with_sidebar'

  def edit
    @profile.press.build
  end

  def update
    if @profile.update(press_params)
      redirect_to profile_press_path, notice: "Successfully Updated Press"
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def press_params
    safe_params = params.require(:profile).permit(press_attributes: [:id, :name, :url, :_destroy])
    rejected_params = safe_params[:press_attributes].reject do |id, press|
      press[:name].blank? && press[:url].blank?
    end
    {'press_attributes' => rejected_params}
  end
end
