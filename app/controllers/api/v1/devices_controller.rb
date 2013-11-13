class Api::V1::DevicesController < Api::V1::AuthenticatedController
  def create
    if current_user.devices.exists?(token: params[:device][:token])
      render json: {}, status: 200
      return
    end

    device = current_user.devices.create(device_params)
    if device.save
      render json: device
    else
      render json: { errors: device.errors }, status: 400
    end
  end

  private

  def device_params
    params.require(:device).permit(:token)
  end
end
