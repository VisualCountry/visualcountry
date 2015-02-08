Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users, controllers: {
    registrations: :registrations,
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
      patch 'interests' => 'interests#update'
      get 'press' => 'press#edit'
      patch 'press' => 'press#update'
      get 'clients' => 'clients#edit'
      patch 'clients' => 'clients#update'
    end
  end

  resources :users, only: [:show], path: :profiles, as: :profiles
  resources :contact_messages, only: [:create]

  get 'content-creators' => 'pages#creators'
  get 'brands-agencies' => 'pages#brands'

end
