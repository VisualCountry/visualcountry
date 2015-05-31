class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def authorize_admin!
    if !current_user.has_account?
      authenticate_user!
    end

    unless current_user.admin?
      flash[:alert] = 'You are not authorized'
      redirect_to root_path
    end
  end

  def current_user
    super || Guest.new
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || profile_path(resource)
  end

  protected

  def configure_permitted_parameters
    configure_sign_in_sanitizer
    configure_sign_up_sanitizer
    configure_account_update_sanitizer
  end

  def configure_sign_up_sanitizer
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(
        :email,
        :password,
        :password_confirmation,
        :remember_me,
        :name,
        :website,
        :city,
        :bio,
        :picture,
      )
    end
  end

  def configure_sign_in_sanitizer
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(
        :email,
        :password,
        :remember_me,
      )
    end
  end

  def configure_account_update_sanitizer
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(
        :email,
        :password,
        :password_confirmation,
        :name,
        :website,
        :city,
        :bio,
        :focus_tokens,
        :ethnicity,
        :gender,
        :birthday,
        :picture,
        {
          presses_attributes: [
            :publication_name,
            :url,
          ]
        },
        {
          clients_attributes: [
            :client_name,
            :url,
          ]
        },
        {
          interest_ids: [],
        },
      )
    end
  end
end
