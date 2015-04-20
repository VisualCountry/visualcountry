Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users, controllers: {
    registrations: :registrations,
    omniauth_callbacks: :omniauth_callbacks,
  }

  namespace :api do
    resources :focuses, only: [:index]
  end

  get '/admin' => 'admin/dashboard#index'

  namespace :admin do
    resources :contact_messages, only: [:index, :show]
  end

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
    get 'search' => 'search#new'
    get 'search/results' => 'search#index'
  end

  resources :users, only: [:show], path: :profiles, as: :profiles
  resources :contact_messages, only: [:create, :destroy]
  resources :influencer_lists, path: :lists
  resources :list_memberships, only: [:create, :destroy]
  resources :bulk_list_memberships, only: [:create]
  resources :omniauth_add_email, only: [:new, :create]
  post "list-copy" => "list_copies#create"

  get 'content-creators' => 'pages#creators'
  get 'brands-agencies' => 'pages#brands'
  get "about" => "pages#about"
  get "team" => "pages#team"
  get "contact" => "pages#contact"
  get "faq" => "pages#faq"
  get "jobs" => "pages#jobs"
  get "terms" => "pages#terms"
  get "privacy" => "pages#privacy"
  get "about" => "pages#about"
end
