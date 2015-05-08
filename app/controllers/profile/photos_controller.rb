class Profile::PhotosController < ApplicationController
  before_action :authenticate_user!
  before_filter :set_album

  def show
    @photo = @album.photos.find params[:id]
  end

  def new
    @photo = @album.photos.new
  end

  def create
    @photo = @album.photos.new params[:photo]
    @photo.album = @album
    if @photo.save
      redirect_to profile_albums_path
    else
      render :new
    end
  end

  def edit
    @photo = @album.photos.find params[:id]
  end

  def update
    @photo = @album.photos.find params[:id]

    if @photo.update_attributes params[:photo]
      redirect_to @album
    else
      render :edit
    end
  end

  private
  def photo_params
    params.require(:photo).permit(:title, :file)
  end

  def set_album
    @album = Album.find params[:album_id]
  end
end
