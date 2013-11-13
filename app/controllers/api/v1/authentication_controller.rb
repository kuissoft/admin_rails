class Api::V1::AuthenticationController < Api::V1::ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password])
      render json: { user_id: user.id, authentication_token: user.authentication_token }, status: 200
    else
      render json: {}, status: 401
    end
  end

  def validate
    user = User.find_by_id(params[:user_id])

    # TODO - refactor to authentication service
    if user && user.authentication_token == params[:token]
      # if user.expired_token?
      #   render json: { error: { code: 1, message: "Authentication token expired" } }, status: 401
      #   user.assign_new_token
      # else
        render json: {}, status: 200
      # end
    elsif user && user.last_token == params[:token]
      render json: { error: { code: 1, message: "Authentication token expired" } }, status: 401
    else
      render json: { error: { code: 2, message: "Invalid authentication token" } }, status: 401
    end
  end
end
