class Profile::AlbumsController < ApplicationController
  before_action :authenticate_user!

  def show
    @album = Album.find params[:id]
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new album_params[:album]
    if @album.save
      redirect_to profile_albums_path
    else
      render :new
    end
  end

  private
  def album_params
    params.require(:album).permit(:title)
  end
end