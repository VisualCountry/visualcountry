class Api::FocusesController < ApplicationController
  def index
    @focuses = Focus.where('name ILIKE ?', "%#{params[:q]}%").order(:name)
    render json: @focuses
  end
end
