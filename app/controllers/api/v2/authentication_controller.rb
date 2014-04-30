class Api::V2::AuthenticationController < Api::V2::ApplicationController

  def create
    user = User.find_by_email(params[:email])
    device = Device.where(user_id: user.id).first
    if device && user.valid_password?(params[:password])
      render json: { user_id: user.id, auth_token: device.auth_token, name: user.name }, status: 200
    else
      render json: {}, status: 401
    end
  end

  
  

  

  

  


end
