class Profile::ClientsController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update(clients_params)
      redirect_to profile_clients_path
    else
      render :edit
    end
  end

  private

  def clients_params
    params.require(:user).permit(clients_attributes: [:id, :name, :url, :_destroy])
  end
end
