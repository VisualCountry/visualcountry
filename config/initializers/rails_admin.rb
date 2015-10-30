RailsAdmin.config do |config|
  config.main_app_name = 'Visual Country'

  config.actions do
    dashboard
    index
    new
    export
    bulk_delete
    edit
    delete
    show_in_app
  end

  config.included_models = %w(ContactMessage Profile User)

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
      :vine_token,

      #TODO: Remove after columns are removed
      :username,
      :name,
      :city,
      :bio,
      :picture,
      :website,
      :cached_instagram_follower_count,
      :cached_twitter_follower_count,
      :cached_vine_follower_count,
      :cached_facebook_follower_count,
      :cached_pinterest_follower_count,
      :total_follower_count,
      :gender,
      :latitude,
      :longitude,
      :birthday,
      :ethnicity,
      :special_interests,
      :influencer_lists
    )
  end
end
