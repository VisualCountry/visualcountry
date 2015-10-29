RailsAdmin.config do |config|
  config.main_app_name = 'Visual Country'

  config.audit_with :paper_trail, 'User', 'PaperTrail::Version'

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    edit
    delete
    show_in_app
    history_index
    history_show
  end

  config.included_models = ['ContactMessage', 'Profile', 'User']

  config.model 'Profile' do
    list do
      field :id
      field :name
      field :total_follower_count
      field :user
    end
  end

  config.model 'User' do
    object_label_method :email

    list do
      field :id
      field :profile
      field :email
    end

    exclude_fields(
      :confirmation_sent_at,
      :confirmation_token,
      :confirmed_at,
      :created_at,
      :current_sign_in_at,
      :current_sign_in_ip,
      :facebook_token,
      :facebook_token_expiration,
      :facebook_uid,
      :instagram_token,
      :last_sign_in_at,
      :last_sign_in_ip,
      :organization_memberships,
      :pinterest_token,
      :remember_created_at,
      :reset_password_sent_at,
      :reset_password_token,
      :sign_in_count,
      :twitter_token,
      :twitter_token_secret,
      :twitter_uid,
      :updated_at,
      :vine_email,
      :vine_password,
      :vine_token
    )
  end
end
