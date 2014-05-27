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
  resources :services
  resources :devices
  resources :activity_monitor do
    get :refresh_logs, on: :collection
  end
  resources :feedbacks, only: [:index, :show, :destroy]
  resources :dashboard, only: [:index]

  match "*path", :to => "application#routing_error", :via => :all
end
