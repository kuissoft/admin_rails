class Api::V1::AuthenticationController < Api::V1::ApplicationController

  def create
    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password])
      render json: { user_id: user.id, auth_token: user.auth_token, name: user.name }, status: 200
    else
      render json: {}, status: 401
    end
  end

  def validate
    user = User.find_by_id(params[:user_id])

    # TODO - refactor to authentication service
    if user && user.auth_token == params[:token]
      # if user.expired_token?
      #   render json: { error_info: { code: 1, message: "Authentication token expired" } }, status: 401
      #   user.assign_new_token
      # else
      render json: {name: user.name, role: user.role }, status: 200
      # end
    elsif user && user.last_token == params[:token]
      render json: { error_info: { code: 102, title: 'Token expired', message: 'Authentication token expired'} }, status: 401
    else
      render json: { error_info: { code: 103, title: '', message: 'Validation code not match'} }, status: 401
    end
  end
  # Resister user or send new code to activate new device
  # curl http://localhost:3000/api/authentication/register -d 'email=name@example.com'
  def register
    # Find user by e-mail
    # user = User.find_by_email(params[:email])
    phone = "+#{params[:phone]}".gsub(" ","")
    user = User.find_by_phone(phone)


    # If user not exists => create new user
    # TODO - What about password? How do I log in on web?
    unless user
      begin
        user = User.create!(phone: phone, password: 'asdfasdf')
      rescue
        err = 101
      end
    end


    # Generate Validation code
    user.update validation_code: 100000 + SecureRandom.random_number(900000) if user

    # If user is ok and has validation code
    # send e-mail notification and catch errors
    # If there is any error send and error response
    # else send 200
    if user and user.validation_code
      # if Emailer.authentication_email(user).deliver
      sms = send_sms_or_email(user)
      if sms.first
        render json: {}, status: 200
      else
        render json: { error_info: { code: 106, title:'', message: sms.last } }, status: 401
      end
    else
      if err == 101
        render json: { error_info: { code: 101, title: '', message: "Wrong format or blank phone number" } }, status: 401
      else
        render json: { error_info: { code: 100, title: 'UNDEFINED ERROR', message: ''} }, status: 401
      end
    end


  end

  def send_sms_or_email user
    msg = "PIN: #{user.validation_code}. Thank you for using Remote Assistant"
    if user.admin?
      Emailer.authentication_email(user).deliver
      sms = [true, nil]
    else
      sms = Sms.new(user.phone, msg).deliver
    end
    sms
  end

  # Resend verification code
  # curl http://localhost:3000/api/authentication/resend_verification_code -d 'phone=420xxxxxxxxx'
  #
  def resend_verification_code
    phone = "+#{params[:phone]}".gsub(" ","")
    user = User.find_by_phone(phone)

    if user
      # If user request verification 3 times send user that he reached limit 
      if user.verification_code_sent_count == 2
        render json: { error_info: { code: 114, title:'', message: 'Resend Verification code limit reached' } }, status: 401
      else
        # if user has no verification code 
        unless user.validation_code.present?
          # Generate Validation code
          user.update validation_code: 100000 + SecureRandom.random_number(900000)
        end
        # send sms
        sms = send_sms_or_email(user)
        if sms.first
          user.update(verification_code_sent_count:  user.verification_code_sent_count += 1)
          render json: {}, status: 200
        else
          render json: { error_info: { code: 106, title:'', message: sms.last } }, status: 401
        end
      end
    else
      render json: { error_info: { code: 111, title: '', message: 'User not exists' } }, status: 401
    end
  end

  # Validate recieved validation code
  # curl http://localhost:3000/api/authentication/validate_code -d 'email=name@example.com&validation_code=1234'
  #
  # TODO - validate device
  # TODO - validate via phone
  def validate_code
    phone = "+#{params[:phone]}".gsub(" ","")
    # Find user by e-mail
    user = User.find_by_phone(phone)

    # If user exists or send error response
    if user
      # Delete validation code after 3 wrong attempts
      user.update validation_code: nil, verification_code_sent_count: 0, verification_code_invalid_count: 0 if user.verification_code_invalid_count == 3
      # If user has validation code generated or send error response
      if user.validation_code
        # If validation code on db match with recieved code or send error response
        if user.validation_code == params[:validation_code]
          # Nil validation code
          user.update validation_code: nil, verification_code_sent_count: 0, verification_code_invalid_count: 0
          # render json: {user: user}, status: 200
          render json: user, status: 200, serializer: UserSerializer
        else
          # Count invalid attempts
          user.update verification_code_invalid_count: user.verification_code_invalid_count += 1
          render json: { error_info: { code: 109, title: '', message: 'Validation code not match'} }, status: 401
        end
      else
        render json: { error_info: { code: 110, title: '', message: 'No validation code' } }, status: 401
      end
    else
      render json: { error_info: { code: 111, title: '', message: 'User not exists' } }, status: 401
    end
  end


end
