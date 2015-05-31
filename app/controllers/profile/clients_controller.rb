class Profile::ClientsController < ApplicationController
  before_action :authenticate_user!

  layout "application_with_sidebar"

  def edit
    current_user.clients.build
  end

  def update
    if current_user.update(clients_params)
      redirect_to profile_clients_path, notice: "Successfully Updated Clients"
    else
      render :edit
    end
  end

  private

  def clients_params
    safe_params = params.require(:user).permit(clients_attributes: [:id, :name, :url, :_destroy])
    rejected_params = safe_params[:clients_attributes].reject do |id, client|
      client[:name].blank? && client[:url].blank?
    end
    {'clients_attributes' => rejected_params}
  end
end
