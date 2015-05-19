class RegistrationsController < Devise::RegistrationsController

  layout "application_with_sidebar", only: [:update, :edit]

  protected

  def update_resource(resource, params)
    focus_tokens = params[:focus_tokens]
    params.delete(:focus_tokens)
    params.delete(:password) if params[:password].empty?
    params.delete(:password_confirmation) if params[:password_confirmation].empty?
    focus_ids = focus_tokens.split(',')
    params.merge!({focus_ids: focus_ids})
    resource.update_without_password(params)
  end

  def after_sign_up_path_for(_)
    profile_social_path
  end

  def after_update_path_for(_)
    edit_user_registration_path
  end
end
