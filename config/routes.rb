RemoteAssistant::Application.routes.draw do

  get "devices/index"
  get "notifications/index"
  resources :web_info, only: [:index, :destroy]
  resources :connections

  get '/status', to: redirect('/status.html')

  devise_for :users, controllers: { sessions: "admin/sessions" }
  # web routes
  root :to => "dashboard#index"
  get '/dashboard/twilio', :to => 'dashboard#twilio', format: 'js'

  resources :users do
    member do
      put :expire_token
      put :reset_password
      put :reset_sms
      put :deauthenticate
    end
    delete :destroy_connection, on: :collection
  end
  resources :sessions, :except => [:edit, :update]
  resources :locations
  resources :contacts
  resources :settings
  resources :devices
  resources :activity_monitor do
    get :refresh_logs, on: :collection
  end
  resources :feedbacks, only: [:index, :show, :destroy]
  resources :dashboard, only: [:index]

  # api routes
  namespace :api, defaults: {format: 'json'} do
    api_version(:module => "V1", :path => {:value => "v1"}, :default => true) do
      resources :devices, only: [:create] do
        put :change_language, on: :collection
        put :set_offline, on: :collection
        put :set_all_offline, on: :collection
      end
      resources :calls
      resources :notifications
      resources :sessions, :except => [:edit, :update]
      resources :locations
      resources :feedbacks, only: [:create]
      resources :users, only: [:update] do
        member do
        end
        put :remove_photo

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
      post "/authentication/authenticate", to: "authentication#authenticate"
      post "/authentication/deauthenticate", to: "authentication#deauthenticate"
      post "/authentication/verify_code", to: "authentication#verify_code"
      post "/authentication/resend_code", to: "authentication#resend_verification_code"
      get '/ping', :to => 'application#ping'
    end
  end

  # api routes
  namespace :api, defaults: {format: 'json'} do
    api_version(:module => "V2", :path => {:value => "v2"}) do
      resources :devices, except: [:create, :update, :new, :edit, :destroy, :index, :show] do
        collection do
          post :authenticate
          post :deauthenticate
          post :validate
          post :verify_code
          post :resend_code
          post :apns_token
          put :change_language
          put :set_offline
          put :set_all_offline
        end
      end
      resources :calls do
        get :dummy_call, on: :collection
      end
      resources :notifications
      resources :sessions, :except => [:edit, :update]
      resources :locations
      resources :feedbacks, only: [:create]
      resources :users, only: [:update] do
        member do
        end
        put :remove_photo

        resources :contacts do
          collection do
            get :connections
            post :accept
            post :decline
            delete :remove
            delete :dismiss
            post :invite
            delete :cancel_invitation
          end
        end
      end
      post "/authentication", to: "authentication#create"
      get '/ping', :to => 'application#ping'
    end
  end

  # api routes
  namespace :api, defaults: {format: 'json'} do
    api_version(:module => "V3", :path => {:value => "v3"}) do
      resources :devices, except: [:create, :update, :new, :edit, :destroy, :index, :show] do
        collection do
          post :authenticate
          post :deauthenticate
          post :validate
          post :verify_code
          post :resend_code
          post :apns_token
          put :change_language
          put :set_offline
          put :set_all_offline
        end
      end
      resources :calls do
        get :dummy_call, on: :collection
      end
      resources :notifications
      resources :sessions, :except => [:edit, :update]
      resources :locations
      resources :feedbacks, only: [:create]
      resources :users, only: [:update] do
        member do
        end
        put :remove_photo

        resources :contacts do
          collection do
            get :connections
            post :accept
            post :decline
            delete :remove
            delete :dismiss
            post :invite
            delete :cancel_invitation
          end
        end
      end
      post "/authentication", to: "authentication#create"
      get '/ping', :to => 'application#ping'
    end
  end
  match "*path", :to => "application#routing_error", :via => :all
end
