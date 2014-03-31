class Api::V1::DevicesController < Api::V1::AuthenticatedController
  skip_before_action :authenticate_user_from_token!, only: [:change_language, :set_all_offline]
  def create
    # Find if device token exists for another user
    device = Device.where("token = ? and user_id != ?", params[:device][:token], current_user.id).first

    # If device exists and has different user_id destroy it
    device.update token: nil if device

    # Check if exists zombie devices and if yes kill them all
    zombie_devices = Device.where("token = ? AND user_id = ? AND uuid != ", params[:device][:token], current_user.id, params[:uuid] )
    zombie_devices.destroy_all

    # If I have device registered just return 200
    if current_user.devices.exists?(token: params[:device][:token], uuid: params[:uuid])
      render json: {}, status: 200
      return
    end

    # If device is not registered -> register it to my user_id
    if device = current_user.devices.where(uuid: params[:uuid]).first.update(device_params)
      render json: {}, status: 200
    else
      render json: { error_info: { code: 101, message: device.errors.full_message.join(", ") } }, status: 400
    end
  end


  def set_offline
    device = current_user.devices.where(uuid: params[:uuid]).first

    if device
      if device.update online: params[:is_online], last_online_at: params[:last_online_at]
        render json: {}, status: 200
      else
        Rails.logger.error '==========START DEBUG============'
        Rails.logger.error "Device update error: #{device.errors.inspect}"
        Rails.logger.error '===========END DEBUG============='
      end
    else
      render json: { error_info: { code: 115, message: t('errors.device_not_exist') } }, status: 400
    end
    # update device status if device disconnect
  end

  def set_all_offline
    devices = Device.all
    error = false
    devices.each do |device|
      unless device.update online: false, last_online_at: Time.now
        Rails.logger.error '==========START DEBUG============'
        Rails.logger.error "All devices set to offline error: #{device.errors.inspect}"
        Rails.logger.error '===========END DEBUG============='
        error = true
      end
    end
    unless error
      render json: {}, status: 200
    else
      render json: { error_info: { code: 100, title: t('errors.undefined_error_title'), message: ''} }, status: 401
    end
  end

  def change_language
    device = Device.where(phone: params[:phone], uuid: params[:uuid]).first
    if device
      render json: {}, status: 200 if device.update language: params[:language]
    else
      render json: { error_info: { code: 115, message: t('errors.device_not_exist') } }, status: 400
    end
  end

  private

  def device_params
    params.require(:device).permit(:token, :uuid)
  end
end
