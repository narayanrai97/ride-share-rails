Rails.application.routes.draw do

  resources :drivers do
    resources :vehicles, shallow: true
    put :accept
    put :reject
    put :pass
    put :fail
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
  devise_for :drivers
  devise_for :riders, :skip => [:registrations],  path: 'riders', controllers: {sessions: "riders/sessions"}

  resources :riders do
    collection do
      get 'edit/:rider_id' => 'riders#edit'
      post 'bulk_update'
    end
  end

  devise_scope :rider do
    resource :riders,
             controller: 'devise/registrations',
             as: :rider_registration do
              get 'cancel'
             end
             get 'sort-down' => 'riders#sort_down'
  end

  mount Api::Base, at: "/"
  mount GrapeSwaggerRails::Engine, at: "/documentation"

  get 'welcome/index'
  get 'welcome/welcome'
  get 'welcome/rider'


  resources :rides
  resources :admin_ride do
    member do
      put 'approve' => 'admin_ride#approve'
      put 'reject' => 'admin_ride#reject'
    end
  end
  resources :tokens, path_names: { new: 'new/:rider_id' } do
    collection do
      get 'bulk_form/:id' => 'tokens#bulk_form', as: 'bulk_form'
      post 'bulk_update'
    end
  end


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

  namespace :riders do
    root :to => "welcome#rider"
    resources :tokens

  end

end
