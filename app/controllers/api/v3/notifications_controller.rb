class Api::V3::NotificationsController < Api::V3::ApplicationController

  def index
    # user = User.where(id: params[:user_id], auth_token: params[:auth_token]).first
    device = Device.where(user_id: params[:user_id], uuid: params[:uuid]).first
    if device and params[:auth_token].present? and (device.auth_token == params[:auth_token] or device.last_token == params[:auth_token])
      user = device.user
      notifications = create_notification(user.contact_connections.where(is_pending: true)) + create_notification(user.connections.where(is_rejected: true),'rejection') + create_notification(user.connections.where(is_removed: true),'removal')

      render json: {notifications: notifications}, status: 200
    else
      render json: { error_info: { code: 111, title: '', message: t('errors.user_not_exist', locale: @language)} }, status: 400
    end
  end


  def create
    key = SecureRandom.urlsafe_base64
    Rails.logger.warn "Saving #{key} with #{params}"
    Rails.cache.write(key, params)

    devices = Device.where(user_id: params[:assistant_id])
    # device_ids = Device.where(user_id: params[:assistant_id]).map(&:apns_token)
    Rails.logger.warn "Found devices #{devices}"
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

    if devices.any?
      if has_at_least_one_apns_token?(devices)
        devices.each do |device|
          unless device.apns_token.blank?
            n = Rpush::Apns::Notification.new
            n.app = Rpush::Apns::App.find_by_name("ios_app")
            n.device_token = device.apns_token
            n.alert = t('sms.request', user: name, locale: set_lang!(device.language))
            #n.attributes_for_device = { call_id: key }
            n.sound = "Calling.wav"
            result = n.save!
          end
        end
        render json: {}, status: 200
        Rpush.push
      else
        render json: {}, status: 204
      end
    else
      render json: {}, status: 204
    end

    
  end

  def has_at_least_one_apns_token? devices
    has_apns_token = false
    devices.each do |device|
      has_apns_token = true unless device.apns_token.blank?
    end
    has_apns_token
  end

  def set_lang! lang
    lang = 'en' unless lang == 'cs' or lang == 'sk'
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
