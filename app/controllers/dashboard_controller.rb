class DashboardController < ApplicationController
  # GET /users
  # GET /users.json
  def index
  	if not current_user
    	redirect_to new_user_session_path
    end
    @users = User.sorted
    require 'twilio-ruby'
    account_sid = get_settings_value(:twillio_account_sid) 
    auth_token = get_settings_value(:twillio_auth_token) 
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
