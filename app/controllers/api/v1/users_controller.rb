class Api::V1::UsersController < Api::V1::ApplicationController
  respond_to :json


  def update
    user = User.where(id: params[:id], auth_token: params[:user][:auth_token]).first
    if user
      if user.update(user_params_change)
        render json: {success: true}, status: 200
      else
        render json: { error: user.errors }, status: 422
      end
    else
      render json: { error: { code: 2, message: "Invalid authentication token" } }, status: 401
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password)
  end

  def user_params_change
    params.require(:user).permit(:name, :email)
  end
end

