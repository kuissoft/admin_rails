class Api::V2::UsersController < Api::V2::ApplicationController
  respond_to :json

  def update
    device = Device.where(user_id: params[:id], uuid: params[:uuid]).first
    if device and params[:user][:auth_token].present? and (device.auth_token == params[:user][:auth_token] or device.last_token == params[:user][:auth_token])
      
      device.update! online: params[:is_online] 
      user = device.user
      if user.update(user_params_change)
        photo_url = "#{IMAGES_HOST}#{user.photo.url.gsub(/_.*/,'')}" if user.photo.present?
        render json: { user: { id: user.id, name: user.name, email: user.email, phone: user.phone, role: user.role, auth_token: device.auth_token, last_token: device.last_token, token_updated_at: device.token_updated_at, photo_url: photo_url }}, status: 200
      else
        render json: { error_info: { code: 101, title: '', message: user.errors.full_messages.join(", ") } }, status: 422
      end
    else
      render json: { error_info: { code: 103, title: '',  message: t('errors.token_invalid', locale: @language) } }, status: 401
    end
  end

  # Remove photo
  def remove_photo
    device = Device.where(user_id: params[:id], uuid: params[:uuid]).first
    if device and params[:user][:auth_token].present? and (device.auth_token == params[:user][:auth_token] or device.last_token == params[:user][:auth_token])
      user = device.user
      user.photo = nil
      user.save
      render json: {}, status: 200
    else
      render json: { error_info: { code: 103, title: '',  message: t('errors.token_invalid', locale: @language) } }, status: 401
    end 
  end


  private
  def user_params
    params.require(:user).permit(:name, :phone, :email, :password)
  end

  def user_params_change
    params.require(:user).permit(:name, :email, :last_sign_in_at, :photo)
  end
end

