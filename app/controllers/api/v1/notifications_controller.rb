class Api::V1::NotificationsController < Api::V1::ApplicationController

  def index
    user = User.where(id: params[:user_id], auth_token: params[:auth_token]).first
    if user
      notifications = create_notification(user.contact_connections.where(is_pending: true)) + create_notification(user.connections.where(is_rejected: true),'rejection') + create_notification(user.connections.where(is_removed: true),'removal')

      render json: {notifications: notifications}, status: 200
    else
      render json: { error: { code: 111} }, status: 400
    end
  end


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
      n.alert = "Request from #{User.find(params[:caller_id]).name}"
      n.attributes_for_device = { call_id: key }
      n.sound = "Calling.wav"
      n.save!
    end

    Rapns.push

    render json: {}, status: 200
  end

  def create_notification data, type = 'invitation'
    notifications = []
    data.each do |d|
      if type == 'invitation'
        notifications << Notification.new(type, d.contact_id, d.user_id)
      else
        notifications << Notification.new(type, d.user_id, d.contact_id)
      end
    end
    notifications
  end
end
