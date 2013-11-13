class Api::V1::NotificationsController < Api::V1::ApplicationController
  def create
    key = SecureRandom.urlsafe_base64
    Rails.logger.warn "Saving #{key} with #{params}"
    Rails.cache.write(key, params)

    device_ids = Device.where(user_id: params[:assistant_id]).map(&:token)
    Rails.logger.warn "Found devices #{device_ids}"

    device_ids.each do |device_id|
      n = Rapns::Apns::Notification.new
      n.app = Rapns::Apns::App.find_by_name("ios_app")
      n.device_token = device_id
      n.alert = User.find(params[:caller_id]).name
      n.attributes_for_device = { call_id: key }
      n.save!
    end

    Rapns.push

    render json: {}, status: 200
  end
end
