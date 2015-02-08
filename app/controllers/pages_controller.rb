class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:connect]
  before_action :set_contact_message, only: [:creators, :brands]

  def home
  end

  def creators
  end

  def brands
  end

  def connect
  end

  private

  def set_contact_message
    @contact_message = ContactMessage.new
  end

end
