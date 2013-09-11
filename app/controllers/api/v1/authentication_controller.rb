class Api::V1::AuthenticationController < Api::V1::ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password])
      render json: { authentication_token: user.authentication_token}, status: 200
    else
      head 401
    end
  end
end
