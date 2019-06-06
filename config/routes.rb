Rails.application.routes.draw do

  devise_for :users
  devise_for :organizations, controllers: {registrations: "organizations/registrations"}
  devise_for :drivers
  devise_for :riders
  mount Api::Base, at: "/"
  mount GrapeSwaggerRails::Engine, at: "/documentation"


  get 'welcome/index'
  get 'welcome/welcome'
  get 'welcome/rider'

  resources :drivers
  resources :riders
  resources :rides
  resources :organizations
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

  namespace :rider do
    root :to => "welcome#rider"
  end

end
