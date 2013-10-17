class Api::V1::AuthenticatedController < Api::V1::ApplicationController
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  private

  def authenticate_user_from_token!
    user = User.where("authentication_token = ? OR last_token = ?", params[:auth_token], params[:auth_token]).first

    if user
      if user.authentication_token == params[:auth_token]
        if user.expired_token?
          user.assign_new_token
          user.save!

          render json: { error: { code: 1, message: "Authentication token expired" } }, status: 401
        else
          sign_in user, store: false
        end
      elsif user.last_token == params[:auth_token]
        render json: { error: { code: 1, message: "Authentication token expired" } }, status: 401
      end
    end
  end
end
