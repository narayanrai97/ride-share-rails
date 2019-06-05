Rails.application.routes.draw do

  resources :drivers do
    resources :vehicles, shallow: true
  end
  devise_for :users
  devise_for :organizations, controllers: {registrations: "organizations/registrations"}
  #changed to signular because conflicts with other driver routes
  devise_for :driver
  devise_for :riders
  mount Api::Base, at: "/"
  mount GrapeSwaggerRails::Engine, at: "/documentation"





  get 'welcome/index'


  resources :riders
  resources :rides
  resources :organizations
  resources :tokens,  path_names: { new: 'new/:rider_id' }


  root 'welcome#index'

  namespace :api, :defaults => {:format => :json} do
    as :driver do
      post   "v1/sign-in"       => "v1/sessions#create"
      delete "v1/sign-out"      => "v1/sessions#destroy"
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
