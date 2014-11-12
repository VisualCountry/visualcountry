class PressesController < ApplicationController
  before_action :set_press, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @presses = Press.all
    respond_with(@presses)
  end

  def show
    respond_with(@press)
  end

  def new
    @press = Press.new
    respond_with(@press)
  end

  def edit
  end

  def create
    @press = Press.new(press_params)
    @press.save
    respond_with(@press)
  end

  def update
    @press.update(press_params)
    respond_with(@press)
  end

  def destroy
    @press.destroy
    respond_with(@press)
  end

  private
    def set_press
      @press = Press.find(params[:id])
    end

    def press_params
      params.require(:press).permit(:publication_name, :url, :id, :_destroy)
    end
end
