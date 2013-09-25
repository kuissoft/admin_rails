class Api::V1::AuthenticationController < Api::V1::ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password])
      render json: { user_id: user.id, authentication_token: user.authentication_token }, status: 200
    else
      render json: {}, status: 401
    end
  end
end
