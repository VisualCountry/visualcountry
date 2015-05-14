class Profile::PressController < ApplicationController
  before_action :authenticate_user!
  layout 'application_with_sidebar'

  def edit
    current_user.press.build
  end

  def update
    if current_user.update(press_params)
      redirect_to profile_press_path
    else
      render :edit
    end
  end

  private

  def press_params
    safe_params = params.require(:user).permit(press_attributes: [:id, :name, :url, :_destroy])
    rejected_params = safe_params[:press_attributes].reject do |id, press|
      press[:name].blank? && press[:url].blank?
    end
    {'press_attributes' => rejected_params}
  end
end
