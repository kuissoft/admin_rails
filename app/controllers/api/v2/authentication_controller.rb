module Api
  module V2
    class Api::V2::AuthenticationController < Api::V2::ApplicationController

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
          user.update is_online: true, connection_type: params[:connection_type]
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
        # Find device by phone
        phone = "+#{params[:phone]}".gsub(" ","")

        device = DeviceControl.where(phone: phone).first

        # If device not exists => create new device and generate verification code
        unless device
          begin
            device = DeviceControl.create!(phone: phone, uuid: params[:uuid], verification_code: 100000 + SecureRandom.random_number(900000))
          rescue
            err = 101
          end
        else
          device.update verification_code: 100000 + SecureRandom.random_number(900000), uuid: params[:uuid]
        end

        # If device is ok and has verification code
        # send e-mail notification and catch errors
        # If there is any error send and error response
        # else send 200
        if device and device.verification_code
          sms = send_sms_or_email(device)
          if sms.first
            device.update sms_count: device.sms_count + 1
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

      def send_sms_or_email device
        allow_send = true
        if device.sms_count == 10 and Time.new < device.created_at + 30.days
          allow_send = false
        elsif device.sms_count == 10 and Time.new > device.created_at + 30.days
          device.update sms_count: 0, created_at: Time.now
          allow_send = true
        end

        if allow_send
          msg = "PIN: #{device.verification_code}. Thank you for using Remote Assistant"
          user = User.where(phone: device.phone).first

          if user and user.admin?
            Emailer.authentication_email(user, device).deliver
            sms = [true, nil]
          else
            sms = Sms.new(device.phone, msg).deliver
          end
        else
          sms = [false, 'You reached maximum limit(10 sms for 30 days) for sending sms. ']
        end
        sms
      end

      # Resend verification code
      # curl http://localhost:3000/api/authentication/resend_verification_code -d 'phone=420xxxxxxxxx'
      #
      def resend_verification_code
        phone = "+#{params[:phone]}".gsub(" ","")
        device = DeviceControl.where(phone: phone).first

        if device
          # If device request verification 1 times send device that he reached limit
          if device.resent and Time.new < device.resent_at + 1.day
            render json: { error_info: { code: 114, title:'', message: 'Resend Verification code limit reached' } }, status: 401
          else
            # Reset resent if it is older than 24 hours
            device.update(resent: false, resent_at: nil) if device.resent_at and Time.new > (device.resent_at + 1.day)
            # if device has no verification code
            unless device.verification_code.present?
              # Generate Validation code
              device.update verification_code: 100000 + SecureRandom.random_number(900000)
            end
            # send sms
            sms = send_sms_or_email(device)
            if sms.first
              device.update sms_count: device.sms_count + 1, resent_at: Time.new, resent: true
              render json: {}, status: 200
            else
              render json: { error_info: { code: 106, title:'', message: sms.last } }, status: 401
            end
          end
        else
          render json: { error_info: { code: 111, title: '', message: 'User not exists' } }, status: 401
        end
      end

      # Validate recieved verification code
      # curl http://localhost:3000/api/authentication/validate_code -d 'email=name@example.com&verification_code=1234'
      #
      # TODO - validate device
      # TODO - validate via phone
      def verify_code
        phone = "+#{params[:phone]}".gsub(" ","")
        device = DeviceControl.where(phone: phone).first


        # If user exists or send error response
        if device
          # Delete verification code after 3 wrong attempts
          device.update verification_code: nil, invalid_count: 0 if device.invalid_count == 3
          # If device has verification code generated or send error response
          if device.verification_code
            # If verification code on db match with recieved code or send error response
            if device.verification_code == params[:verification_code]
              # Nil verification code
              device.update verification_code: nil, invalid_count: 0
              user = User.where(phone: phone).first
              #create user
              user = User.create phone: phone, password: SecureRandom.hex unless user
              render json: user, status: 200, serializer: UserSerializer
            else
              # Count invalid attempts
              device.update invalid_count: device.invalid_count += 1
              render json: { error_info: { code: 109, title: '', message: 'Verification code not match'} }, status: 401
            end
          else
            render json: { error_info: { code: 110, title: '', message: 'No verification code' } }, status: 401
          end
        else
          render json: { error_info: { code: 111, title: '', message: 'User not exists' } }, status: 401
        end
      end


    end
  end
end
