class Api::V1::NotificationsController < Api::V1::ApplicationController

  def index
    user = User.where(id: params[:user_id], auth_token: params[:auth_token]).first
    if user
      notifications = create_notification(user.contact_connections.where(is_pending: true)) + create_notification(user.connections.where(is_rejected: true),'rejection') + create_notification(user.connections.where(is_removed: true),'removal')

      render json: {notifications: notifications}, status: 200
    else
      render json: { error_info: { code: 111, title: '', message: 'User not exists'} }, status: 400
    end
  end


  def create
    key = SecureRandom.urlsafe_base64
    Rails.logger.warn "Saving #{key} with #{params}"
    Rails.cache.write(key, params)

    device_ids = Device.where(user_id: params[:assistant_id]).map(&:token)
    Rails.logger.warn "Found devices #{device_ids}"
    name = "Unknown User"
    con = User.where(id: params[:assistant_id]).first
    user = con.connections.where(contact_id: params[:caller_id]).first
    if user and !user.nickname.blank?
      name = user.nickname
    else
      user = User.where(id: params[:caller_id]).first
      if user
        if user.name.blank?
          name = user.phone
        else
          name = user.name
        end
      end
    end

    device_ids.each do |device_id|
      n = Rpush::Apns::Notification.new
      n.app = Rpush::Apns::App.find_by_name("ios_app")
      n.device_token = device_id
      n.alert = "Request from #{name}"
      n.attributes_for_device = { call_id: key }
      n.sound = "Calling.wav"
      n.save!
    end

    Rpush.push

    render json: {}, status: 200
  end

  def create_notification data, type = 'invitation'
    notifications = []
    data.each do |d|
      if type == 'invitation'
        notifications << Notification.new(type, d.contact_id, d.user_id)
      else
        notifications << Notification.new(type, d.user_id, d.contact_id, d.nickname)
      end
    end
    notifications
  end
end

