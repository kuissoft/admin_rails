module Api
  module V1
    class Api::V1::ApplicationController < Api::V1::ApplicationController
      before_filter :authenticate_user_from_token!
      before_filter :authenticate_user!

      private

      def authenticate_user_from_token!
        user = User.where("auth_token = ? OR last_token = ?", params[:auth_token], params[:auth_token]).first
        # TODO - refactor to authentication service
        if user
          if user.auth_token == params[:auth_token]
            # if user.expired_token?
            #   user.assign_new_token
            #   user.save!

            #   render json: { error: { code: 1, message: "Authentication token expired" } }, status: 401
            # else
              sign_in user, store: false
            # end
          elsif user.last_token == params[:auth_token]
            render json: { error_info: { code: 102, title: '', message: 'Validation code not match'} }, status: 401
          end
        end
      end
    end
  end
end
