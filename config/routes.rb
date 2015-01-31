Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users, controllers: {
    'registrations' => 'users/registrations',
    omniauth_callbacks: :omniauth_callbacks,
  }

  namespace :profile do
    scope :edit do
      get 'social' => 'social_profiles_connection#show'
      scope :social, as: :link do
        delete 'pinterest' => 'pinterest_link#destroy'
        delete 'twitter' => 'twitter_link#destroy'
        delete 'facebook' => 'facebook_link#destroy'
        delete 'instagram' => 'instagram_link#destroy'
        delete 'vine' => 'vine#destroy'
        resources :vine, only: [:new, :create]
      end
      get 'interests' => 'interests#edit'
    end
  end

  resources :profiles, only: [:show]

  get 'content-creators' => 'pages#creators'
  get 'brands-agencies' => 'pages#brands'


  # for contact form
  match '/contacts',     to: 'contacts#new',             via: 'get'
  resources "contacts", only: [:new, :create]
end
