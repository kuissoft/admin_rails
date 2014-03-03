class Api::V2::UsersController < Api::V2::ApplicationController
  respond_to :json

  def update
    destroy_device(params) if params[:device].present?
    user = User.where(id: params[:id], auth_token: params[:user][:auth_token]).first
    if user
      if user.update(user_params_change)
        render json: {}, status: 200
      else
        render json: { error_info: { code: 101, title: '', message: user.errors.full_messages.join(", ") } }, status: 422
      end
    else
      render json: { error_info: { code: 103, title: '',  message: t('errors.token_invalid') } }, status: 401
    end
  end

  # Remove avatar
  def remove_avatar
    user = User.where(id: params[:id], auth_token: params[:auth_token]).first
    if user
      user.avatar = nil
      user.save
      render json: {}, status: 200
    else
      render json: { error_info: { code: 103, title: '',  message: t('errors.token_invalid') } }, status: 401
    end 
  end


  private

  def destroy_device params
    # Find if device token exists for another user
    device = Device.where("token = ? and user_id = ?", params[:device][:token], params[:device][:user_id]).first

    # If device exists and has different user_id destroy it
    device.destroy if device
  end

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password)
  end

  def user_params_change
    params.require(:user).permit(:name, :email, :last_sign_in_at, :is_online, :connection_type, :avatar)
  end
end

