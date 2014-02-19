require 'api_constraints'

RemoteAssistant::Application.routes.draw do

  get "devices/index"
  get "notifications/index"
  resources :web_info, only: [:index, :destroy]
  resources :connections

  get '/status', to: redirect('/status.html')

  devise_for :users, controllers: { sessions: "admin/sessions" }
  # web routes
  root 'users#index'
  resources :users do
    member do
      put :expire_token
    end
    delete :destroy_connection, on: :collection
  end
  resources :sessions, :except => [:edit, :update]
  resources :locations
  resources :contacts
  resources :settings
  resources :activity_monitor do 
    get :refresh_logs, on: :collection
  end
  resources :feedbacks, only: [:index, :show, :destroy]

  # api routes
  namespace :api, defaults: {format: 'json'} do
    scope :module => :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :devices, only: [:create]
      resources :calls
      resources :notifications
      resources :sessions, :except => [:edit, :update]
      resources :locations
      resources :feedbacks, only: [:create]
      resources :users, only: [:update] do
        resources :contacts do
          collection do
            get :connections
            post :accept
            post :decline
            delete :remove
            delete :dismiss
            post :invite
          end
        end
      end
      post "/authentication", to: "authentication#create"
      post "/authentication/validate", to: "authentication#validate"
      post "/authentication/register", to: "authentication#register"
      post "/authentication/verify_code", to: "authentication#verify_code"
      post "/authentication/resend_code", to: "authentication#resend_verification_code"
    end
  end
  match "*path", :to => "application#routing_error", :via => :all
end
