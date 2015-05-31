class Profile::RegistrationsController < Devise::RegistrationsController

  def edit
    @user = User.find(current_user)
    @user.presses.build
    @user.clients.build
    render "edit", layout: 'application_with_sidebar'
  end

  def update
    @user = User.find(current_user)
    successfully_updated = if needs_password?(@user, params)

      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to edit_user_registration_path
    else
      render "edit", layout: 'application_with_sidebar'
    end
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      params[:user][:password].present? ||
      params[:user][:password_confirmation].present?
  end
end
