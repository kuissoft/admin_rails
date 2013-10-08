class Api::V1::UsersController < Api::V1::ApplicationController
  respond_to :json

  def create
    user = User.new(user_params.merge(role: User::DEFAULT_ROLE))

    if user.save
      render json: user, status: 201, serializer: RegistrationSerializer, root: "user"
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password)
  end
end
