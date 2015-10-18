class Profile::ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  layout 'application_with_sidebar'

  def edit
    @profile.clients.build
  end

  def update
    if @profile.update(clients_params)
      redirect_to profile_clients_path, notice: "Successfully Updated Clients"
    else
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def clients_params
    safe_params = params.require(:profile).permit(clients_attributes: [:id, :name, :url, :_destroy])
    rejected_params = safe_params[:clients_attributes].reject do |id, client|
      client[:name].blank? && client[:url].blank?
    end
    {'clients_attributes' => rejected_params}
  end
end
