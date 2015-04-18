class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:connect]
  before_action :set_contact_message, only: [:creators, :brands, :contact]

  def home
  end

  def creators
  end

  def brands
  end

  def connect
  end

  def about
  end

  def team
  end

  def contact
  end

  def faq
  end

  def jobs
  end

  def terms
  end

  def privacy
  end

  private

  def set_contact_message
    @contact_message = ContactMessage.new
  end
end
