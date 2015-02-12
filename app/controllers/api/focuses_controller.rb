class Api::FocusesController < ApplicationController
  def index
    @focuses = Focus.all
    render json: @focuses
  end
end
