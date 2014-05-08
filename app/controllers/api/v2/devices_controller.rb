class Api::V2::DevicesController < Api::V2::AuthenticatedController
  skip_before_action :authenticate_user_from_token!, only: [:change_language, :set_all_offline, :authenticate, :verify_code, :resend_code]
  # before_action :verify_api_key!, only: [:authenticate, :verify_code, :resend_code ]
  ###
  # Authenticate new device
  # @url /api/device/authenticate
  # @param {String} phone
  # @param {String} uuid
  # @param {String} language
  ###
  def authenticate
    phone = "+#{params[:phone]}".gsub(" ","")
    device = Device.where(uuid: params[:uuid]).first

    user = User.where(phone: phone).first
    user = User.create phone: phone, password: SecureRandom.hex unless user

    if device
      if device.phone == phone
        device.update language: params[:language], verification_code: 100000 + SecureRandom.random_number(900000), user_id: user.id
      else
        device.update phone: phone, language: params[:language], verification_code: 100000 + SecureRandom.random_number(900000), user_id: user.id
      end
    else
      # If device not exists => create new device and generate verification code
      begin
        device = Device.create!(user_id: user.id, phone: phone, uuid: params[:uuid], language: params[:language], verification_code: 100000 + SecureRandom.random_number(900000))
      rescue => e
        Rails.logger.error "Error when creating device while authenticate: #{e.inspect}"
        err = 116
      end
    end

    # If device is ok and has verification code
    # send e-mail notification and catch errors
    # If there is any error send and error response
    # else send 200
    if device and device.verification_code
      sms = device.send_sms_or_email(user)
      if sms.first
        user.update sms_count: user.sms_count + 1
        render json: {}, status: 200
      else
        render json: { error_info: { code: 106, title:'', message: sms.last } }, status: 401
      end
    else
      if err == 116
        render json: { error_info: { code: 116, title: '', message: t('errors.uuid_exists', locale: set_language_by_area_code(phone)) } }, status: 401
      else
        render json: { error_info: { code: 100, title: t('errors.undefined_error_title', locale: set_language_by_area_code(phone)), message: ''} }, status: 401
      end
    end
  end

  ###
  # Validate recieved verification code
  # @url /api/v2/devices/verify_code
  # @param {String} phone
  # @param {String} uuid
  # @param {String} verification_code
  ###

  def verify_code
    phone = "+#{params[:phone]}".gsub(" ","")
    device = Device.where(phone: phone, uuid: params[:uuid]).first

    # If user exists or send error response
    if device
      # Delete verification code after 3 wrong attempts
      device.update verification_code: nil, invalid_count: 0 if device.invalid_count == 3
      # If device has verification code generated or send error response
      if device.verification_code
        # If verification code on db match with recieved code or send error response
        if device.verification_code == params[:verification_code]

          user = User.where(phone: phone).first
          #create user
          user = User.create phone: phone, password: SecureRandom.hex unless user
          device.update user_id: user.id, verification_code: nil, invalid_count: 0, online: true, resent: false, resent_at: nil
          photo_url = "#{IMAGES_HOST}#{user.photo.url.gsub(/_.*/,'')}" if user.photo.present?
          render json: { user: { id: user.id, name: user.name, email: user.email, phone: user.phone, role: user.role, auth_token: device.auth_token, last_token: device.last_token, token_updated_at: device.token_updated_at, photo_url: photo_url}}, status: 200
        else
          # Count invalid attempts
          device.update invalid_count: device.invalid_count += 1
          lang = device.language
          lang = 'en' unless device.language == 'cs' or device.language == 'sk'
          render json: { error_info: { code: 109, title: '', message: t('errors.verification_not_match', locale: lang)} }, status: 401
        end
      else
        lang = device.language
        lang = 'en' unless device.language == 'cs' or device.language == 'sk'
        render json: { error_info: { code: 110, title: '', message: t('errors.no_verification_code', locale: lang) } }, status: 401
      end
    else
      render json: { error_info: { code: 115, title: '', message: t('errors.device_not_exist', locale: set_language_by_area_code(phone)) } }, status: 401
    end
  end

  ###
  # Resend verification code
  # @url /api/devices/resend_code
  # @param {String} phone
  # @param {String} uuid
  ###

  def resend_code
    phone = "+#{params[:phone]}".gsub(" ","")
    device = Device.where(phone: phone, uuid: params[:uuid]).first
    
    if device
      if user = device.user
        Rails.logger.debug "#{user.inspect}"
        # If device request verification 1 times send device that he reached limit
        if device.resent and Time.new < device.resent_at + 1.day
          lang = device.language
          lang = 'en' unless device.language == 'cs' or device.language == 'sk'
          render json: { error_info: { code: 114, title:'', message: t('errors.resend_limit', locale: lang) } }, status: 401
        else
          # Reset resent if it is older than 24 hours
          device.update(resent: false, resent_at: nil) if device.resent_at and Time.new > (device.resent_at + 1.day)
          # if device has no verification code
          unless device.verification_code.present?
            # Generate Validation code
            device.update verification_code: 100000 + SecureRandom.random_number(900000)
          end
          # send sms
          sms = device.send_sms_or_email(user)
          if sms.first
            user.update sms_count: user.sms_count + 1
            device.update resent_at: Time.new, resent: true
            render json: {}, status: 200
          else
            render json: { error_info: { code: 106, title:'', message: sms.last } }, status: 401
          end
        end
      else
        lang = device.language
        lang = 'en' unless device.language == 'cs' or device.language == 'sk'
        render json: { error_info: { code: 111, title: '', message: t('errors.user_not_exist', locale: lang ) } }, status: 401
      end
    else
      render json: { error_info: { code: 115, title: '', message: t('errors.device_not_exist', locale: set_language_by_area_code(phone)) } }, status: 401
    end
  end

  ###
  # Device validate
  # * Validate device from Node server
  # @param {Integer} user_id
  # @param {Integer} uuid
  # @param {Integer} auth_token
  ###
  def validate
    user = @device.user
    @device.update online: true, connection_type: params[:connection_type]
    render json: {name: user.name, role: user.role, uuid: @device.uuid }, status: 200
  end

  ###
  # Device deauthenticate
  # * Delete device from devices table
  # @url /api/v2/devices/deauthenticate
  # @param {Integer} user_id
  # @param {Integer} uuid
  # @param {Integer} auth_token
  ###
  def deauthenticate
    # Disconnect device from socket and notify contacts
    Realtime.new.disconnect(current_user.id, @device.uuid, current_user.connections.where("is_rejected = ? AND is_removed = ? ", false, false).map(&:contact_id))
    # Destroy device
    if @device.destroy
      current_user.update last_online_at: Time.now
      render json: {},  status: 200
    else
      Rails.logger.error "Error while deauthenticate a device: #{@device.errors.inspect}"
      lang = @device.language
      lang = 'en' unless @device.language == 'cs' or @device.language == 'sk'
      render json: { error_info: { code: 100, title: t('errors.undefined_error_title', locale: lang), message: ''} }, status: 401
    end
  end


  # Add APNS token to device
  def apns_token
    # If I have device registered just return 200
    if current_user.devices.exists?(apns_token: params[:device][:apns_token], uuid: params[:uuid])
      render json: {}, status: 200
      return
    end

    # If device is not registered -> register it to my user_id
    if @device.update(device_params)
      render json: {}, status: 200
    else
      render json: { error_info: { code: 101, message: device.errors.full_message.join(", ") } }, status: 400
    end
  end


  def set_offline
    device = current_user.devices.where(uuid: params[:uuid]).first

    if device
      if device.update online: params[:is_online], last_online_at: params[:last_online_at], connection_type: nil
        current_user.update last_online_at: params[:last_online_at]
        render json: {}, status: 200
      else
        Rails.logger.error "Device update error: #{device.errors.inspect}"
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
      unless device.update online: false, last_online_at: Time.now, connection_type: nil
        device.user.update last_online_at: Time.now if device.user
        Rails.logger.error "All devices set to offline error: #{device.errors.inspect}"
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

  # def verify_api_key!
  #   unless params[:api_key] == API_KEY
  #     phone = "+#{params[:phone]}".gsub(" ","")
  #     render json: { error_info: { code: 119, title: '', message: t('errors.invalid_api_key', locale: set_language_by_area_code(phone))} }, status: 401 
  #   end
  # end

  def device_params
    params.require(:device).permit(:apns_token, :uuid)
  end
end
