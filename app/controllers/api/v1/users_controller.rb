class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params.merge(role: User::DEFAULT_ROLE))

    if user.save
      render json: user, status: 201
    else
      render json: user, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password)
  end
end
