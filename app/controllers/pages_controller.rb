class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:connect]

  def home
  end

  def creators
  end

  def brands
  end

  def connect
  end

end
