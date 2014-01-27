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
      #   render json: { error: { code: 1, message: "Authentication token expired" } }, status: 401
      #   user.assign_new_token
      # else
      render json: {name: user.name, role: user.role }, status: 200
      # end
    elsif user && user.last_token == params[:token]
      render json: { error: { code: 1, message: "Authentication token expired" } }, status: 401
    else
      render json: { error: { code: 2, message: "Invalid authentication token" } }, status: 401
    end
  end
  # Resister user or send new code to activate new device
  # curl http://localhost:3000/api/authentication/register -d 'email=name@example.com'
  #
  # TODO - find user via phone
  # TODO - send sms validation code
  # TODO - create or register device with device id
  # TODO - Validate device in 10 minutes or STFU
  def register
    # Find user by e-mail
    # user = User.find_by_email(params[:email])
    phone = "+#{params[:phone]}"
    user = User.find_by_phone(phone)


    # If user not exists => create new user
    # TODO - What about password? How do I log in on web?
    unless user
      begin
        user = User.create!(phone: phone, password: 'asdfasdf')
      rescue
        err = 5
      end
    end


    # Generate Validation code
    user.update! validation_code: 100000 + SecureRandom.random_number(900000) if user

    # If user is ok and has validation code
    # send e-mail notification and catch errors
    # If there is any error send and error response
    # else send 200
    if user and user.validation_code
      # if Emailer.authentication_email(user).deliver
      sms = Sms.new(user.phone, user.validation_code).deliver
      if sms.first
        render json: {}, status: 200
      else
        render json: { error: { code: 6, message: "Authentication sms not sent and this is the reason: #{sms.last}" } }, status: 401
      end
    else
      if err == 5
        render json: { error: { code: 5, message: "Wrong user parametres" } }, status: 401
      else
        render json: { error: { code: 7, message: "Unknown error" } }, status: 401
      end
    end


  end

  # Validate recieved validation code
  # curl http://localhost:3000/api/authentication/validate_code -d 'email=name@example.com&validation_code=1234'
  #
  # TODO - validate device
  # TODO - validate via phone
  def validate_code
    phone = "+#{params[:phone]}"
    # Find user by e-mail
    user = User.find_by_phone(phone)

    # If user exists or send error response
    if user
      # If user has validation code generated or send error response
      if user.validation_code
        # If validation code on db match with recieved code or send error response
        if user.validation_code == params[:validation_code]
          # Nil validation code
          user.update! validation_code: nil
          # render json: {user: user}, status: 200
          render json: user, status: 200, serializer: UserSerializer
        else
          render json: { error: { code: 8, message: "Validation code not match" } }, status: 401
        end
      else
        render json: { error: { code: 9, message: "User has no validation code generated" } }, status: 401
      end
    else
      render json: { error: { code: 10, message: "User not exists" } }, status: 401
    end
  end


end
