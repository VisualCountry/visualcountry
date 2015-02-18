class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    focus_tokens = params[:focus_tokens]
    params.reject! { |k,v| k == 'focus_tokens' }
    focus_ids = focus_tokens.split(',')
    params.merge!({focus_ids: focus_ids})
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end

