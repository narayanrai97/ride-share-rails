Rails.application.routes.draw do
  devise_for :drivers, path: 'drivers', controllers: {sessions: "drivers/sessions"}

  namespace :admin do
    resources :drivers do
      resources :vehicles, shallow: true
      put :accept
      put :reject
      put :pass
      put :fail
      put :activation
    end
  end

  devise_scope :driver do
    get 'ascending_sort' => 'drivers#ascending_sort'
  end

  devise_for :users, skip: [:registrations],path: 'users', controllers: {sessions: "users/sessions"}
  devise_scope :user do
    resource :users,
             only: [:edit, :update, :destroy],
             controller: 'devise/registrations',
             as: :user_registration do
              get 'cancel'
             end
    get 'user' => "welcome#index"
  end

  resources :organizations, controllers: {registrations: "organizations/registrations"}
  # devise_for :riders, :skip => [:registrations],  path: 'riders', controllers: {sessions: "riders/sessions"}

  resources :riders do
    collection do
      get 'edit/:rider_id' => 'riders#edit'
      post 'bulk_update'
    end
    member do
      get 'locations'
    end
    put :activation
  end
  #
  # devise_scope :rider do
  #   resource :riders_devise,
  #            controller: 'devise/registrations',
  #            as: :rider_registration do
  #             get 'cancel'
  #            end
  #            get 'sort-down' => 'riders#sort_down'
  # end

  mount Api::Base, at: "/"
  mount GrapeSwaggerRails::Engine, at: "/documentation"

  get 'welcome/index'
  get 'welcome/welcome'
  get 'welcome/driver'

  get '/privacy_policy' => 'pages#privacy_policy'
  get '/terms_and_conditions' => 'pages#terms_and_conditions'
  get '/support' => 'pages#support'

  resources :rides do
    member do
      put 'cancel' => 'rides#cancel'
    end
  end

  resources :admin_ride do
    member do
      put 'approve' => 'admin_ride#approve'
      get 'review' => 'admin_ride/ride_cancellations#review'
      patch 'cancel' => 'admin_ride/ride_cancellations#cancel'
    end
  end

  resources :tokens, path_names: { new: 'new/:rider_id' }

  root 'welcome#welcome'

  namespace :api, :defaults => {:format => :json} do
    as :driver do
      post   "v1/sign-in"       => "v1/sessions#create"
      delete "v1/sign-out"      => "v1/sessions#destroy"
    end
  end

  namespace :user do
    root :to => "welcome#index"
  end

  # namespace :riders do
  #   root :to => "welcome#rider"
  #   resources :tokens
  #
  # end

end
