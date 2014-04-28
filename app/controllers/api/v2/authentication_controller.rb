class Api::V2::AuthenticationController < Api::V2::ApplicationController

  def create
    user = User.find_by_email(params[:email])
    device = Device.where(user_id: user.id).first
    if device && user.valid_password?(params[:password])
      render json: { user_id: user.id, auth_token: device.auth_token, name: user.name }, status: 200
    else
      render json: {}, status: 401
    end
  end

  def validate
    device = Device.where(user_id: params[:user_id], uuid: params[:uuid]).first

    if device 
      if params[:auth_token].present? and (device.auth_token == params[:auth_token] or device.last_token == params[:auth_token])
        # if user.expired_token?
        #   render json: { error_info: { code: 1, message: "Authentication token expired" } }, status: 401
        #   user.assign_new_token
        # else
        user = device.user
        device.update online: true, connection_type: params[:connection_type]
        render json: {name: user.name, role: user.role, uuid: device.uuid }, status: 200
        # end
      elsif device && device.last_token == params[:auth_token]
        render json: { error_info: { code: 102, title: '', message: t('errors.token_expired')} }, status: 401
      else
        render json: { error_info: { code: 103, title: '', message: t('errors.token_not_match')} }, status: 401
      end
    else
      render json: { error_info: { code: 111, title: '', message: t('errors.user_not_exist') } }, status: 401
    end
  end
  # Resister user or send new code to activate new device
  # curl http://localhost:3000/api/authentication/register -d 'email=name@example.com'
  def authenticate
    # Find device by phone
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
        Rails.logger.error "2: #{e.inspect}"
        err = 116
      end
    end

    # If device is ok and has verification code
    # send e-mail notification and catch errors
    # If there is any error send and error response
    # else send 200
    if device and device.verification_code
      sms = send_sms_or_email(device, user)
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

  def send_sms_or_email device, user
    allow_send = true
    if user.sms_count == 10 and Time.new < user.created_at + 30.days
      allow_send = false
    elsif user.sms_count == 10 and Time.new > user.created_at + 30.days
      user.update sms_count: 0, created_at: Time.now
      allow_send = true
    end

    if allow_send
      lang = device.language
      lang = 'en' unless device.language == 'cs' or device.language == 'sk'

      msg = t('sms.verification', code: device.verification_code, locale: lang)

      if Rails.env == 'development' or (user and user.admin? and get_settings_value(:force_sms) != "1")
        Emailer.authentication_email(user, device).deliver
        sms = [true, nil]
      else
        sms = Sms.new(device.phone, msg).deliver
      end
    else
      sms = [false, t('errors.sms_limit')]
    end
    sms
  end

  # Resend verification code
  # curl http://localhost:3000/api/authentication/resend_verification_code -d 'phone=420xxxxxxxxx'
  #
  def resend_verification_code
    phone = "+#{params[:phone]}".gsub(" ","")
    device = Device.where(phone: phone, uuid: params[:uuid]).first
    user = device.user
    if device and user
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
        sms = send_sms_or_email(device, user)
        if sms.first
          user.update sms_count: user.sms_count + 1
          device.update resent_at: Time.new, resent: true
          render json: {}, status: 200
        else
          render json: { error_info: { code: 106, title:'', message: sms.last } }, status: 401
        end
      end
    else
      render json: { error_info: { code: 111, title: '', message: t('errors.user_not_exist', locale: set_language_by_area_code(phone)) } }, status: 401
    end
  end

  # Validate recieved verification code
  # curl http://localhost:3000/api/authentication/validate_code -d 'email=name@example.com&verification_code=1234'
  #
  # TODO - validate device
  # TODO - validate via phone
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
          device.update user_id: user.id, verification_code: nil, invalid_count: 0, online: true
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
      render json: { error_info: { code: 111, title: '', message: t('errors.user_not_exist', locale: set_language_by_area_code(phone)) } }, status: 401
    end
  end

  ###
  # Device deauthenticate
  # * Delete device from devices table
  ###
  def deauthenticate
    device = Device.where(user_id: params[:user_id], uuid: params[:uuid]).first

    if device
      if params[:auth_token].present? and (device.auth_token == params[:auth_token] or device.last_token == params[:auth_token])
        if device.destroy
          render json: {},  status: 200
        else
          Rails.logger.error '========== DEAUTHENTICATE ERRORS ============'
          Rails.logger.error "#{device.errors.inspect}"
          Rails.logger.error '=========== END DEBUG ============='
          lang = device.language
          lang = 'en' unless device.language == 'cs' or device.language == 'sk'
          render json: { error_info: { code: 100, title: t('errors.undefined_error_title', locale: lang), message: ''} }, status: 401
        end
      else
        lang = device.language
        lang = 'en' unless device.language == 'cs' or device.language == 'sk'
        render json: { error_info: { code: 102, title: '', message: t('errors.token_not_match', locale: lang)} }, status: 401
      end
    else
      render json: { error_info: { code: 111, title: '', message: t('errors.user_not_exist') } }, status: 401
    end
  end


end
