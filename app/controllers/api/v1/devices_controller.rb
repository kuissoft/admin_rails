module Api
  module V1
    class Api::V1::ApplicationController < ActionController::Base
      def create
        # Find if device token exists for another user
        device = Device.where("token = ? and user_id != ?", params[:device][:token], current_user.id).first

        # If device exists and has different user_id destroy it
        device.destroy if device

        # If I have device registered just return 200
        if current_user.devices.exists?(token: params[:device][:token])
          render json: {}, status: 200
          return
        end

        # If device is not registered -> register it to my user_id
        device = current_user.devices.create(device_params)
        if device.save
          render json: device
        else
          render json: { error_info: { code: 101, message: device.errors.full_message.join(", ") } }, status: 400
        end
      end

      private

      def device_params
        params.require(:device).permit(:token)
      end
    end
  end
end
