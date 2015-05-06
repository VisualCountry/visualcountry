class AlbumsController < ApplicationController
  before_action :authenticate_user!

  belongs_to :user

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