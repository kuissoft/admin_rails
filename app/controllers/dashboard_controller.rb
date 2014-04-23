class DashboardController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.sorted
    require 'twilio-ruby'
    account_sid = get_settings_value(:twillio_account_sid) 
    auth_token = get_settings_value(:twillio_auth_token) 
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
