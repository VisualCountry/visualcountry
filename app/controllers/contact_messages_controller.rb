class ContactMessagesController < ApplicationController
  def create
    @contact_message = ContactMessage.new(contact_message_params)

    if @contact_message.save
      flash[:notice] = 'Message sent!'
      redirect_to controller: callback_controller, action: callback_action
    else
      params[:callback_controller] = callback_controller
      params[:callback_action] = callback_action
      render template: "#{callback_controller}/#{callback_action}"
    end
  end

  def destroy
    @contact_message = ContactMessage.find(params[:id])
    if @contact_message.destroy
      redirect_to admin_contact_messages_path
      flash[:success] = "Message Deleted"  #flash not showing on screen
    else
      redirect_to admin_contact_messages_path
      flash[:success] = "Error Deleting Try again"
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email_address, :phone_number, :instagram_account, :vine_account, :body)
  end

  def callback_controller
    params[:contact_message][:callback_controller]
  end

  def callback_action
    params[:contact_message][:callback_action]
  end
end
