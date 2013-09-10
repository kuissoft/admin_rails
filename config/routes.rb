require 'api_constraints'

RemoteAssistant::Application.routes.draw do
  devise_for :users
  # web routes
  root 'sessions#index'
  resources :users
  resources :sessions, :except => [:edit, :update]
  resources :locations

  # api routes
  namespace :api, defaults: {format: 'json'} do
    scope :module => :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sessions, :except => [:edit, :update]
      resources :locations
    end
  end
end
