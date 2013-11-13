require 'api_constraints'

RemoteAssistant::Application.routes.draw do
  resources :connections

  devise_for :users, controllers: { sessions: "admin/sessions" }
  # web routes
  root 'users#index'
  resources :users do
    member do
      put :expire_token
    end
  end
  resources :sessions, :except => [:edit, :update]
  resources :locations
  resources :contacts
  resources :settings

  # api routes
  namespace :api, defaults: {format: 'json'} do
    scope :module => :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :devices, only: [:create]
      resources :notifications
      resources :sessions, :except => [:edit, :update]
      resources :locations
      resources :users do
        resources :contacts do
          collection do
            get :connections
            post :accept
            post :decline
            delete :remove
          end
        end
      end
      post "/authentication", to: "authentication#create"
      post "/authentication/validate", to: "authentication#validate"
    end
  end
end
