class Profile::AlbumsController < ApplicationController
  before_action :authenticate_user!

  def show
    @album = Album.find params[:id]
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new params[:album]
    if @album.save
      redirect_to @album
    else
      render :new
    end
  end
end