class Admin::ContactMessagesController < ApplicationController
  before_action :authorize_admin!

  def index
    @contact_messages = ContactMessage.all
  end

  def show
    @contact_message = ContactMessage.find(params[:id])
  end
end
