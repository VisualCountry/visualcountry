Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users, controllers: {
    'registrations' => 'users/registrations',
    omniauth_callbacks: :omniauth_callbacks,
  }

  namespace :users do
    scope :link do
      get 'social' => 'social_profiles_connection#show'
      delete 'pinterest' => 'pinterest_link#destroy'
      delete 'twitter' => 'twitter_link#destroy'
      delete 'facebook' => 'facebook_link#destroy'
      delete 'instagram' => 'instagram_link#destroy'
      resource 'vine', only: [:new, :create, :destroy]
    end
  end

  resources :pictures
  resources :profiles, only: [:show]

  get 'content-creators' => 'pages#creators'
  get 'brands-agencies' => 'pages#brands'
  get 'interests' => 'pages#interests'

  # for contact form
  match '/contacts',     to: 'contacts#new',             via: 'get'
  resources "contacts", only: [:new, :create]
end
