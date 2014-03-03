class Api::V2::AuthenticatedController < Api::V2::ApplicationController
  before_filter :authenticate_user_from_token!
  #before_filter :authenticate_user!


  private

  def authenticate_user_from_token!
    user = User.where(id: params[:user_id]).first

    if user
      if user.auth_token == params[:auth_token] or user.last_token == params[:auth_token]
        # if user.expired_token?
        #   user.assign_new_token
        #   user.save!

        #   render json: { error: { code: 1, message: "Authentication token expired" } }, status: 401
        # else
        sign_in user, store: false
        # end
      else
        render json: { error_info: { code: 102, title: '', message: t('errors.token_not_match')} }, status: 401
      end
    else
      render json: { error_info: { code: 104, title: '', message: t('errors.user_not_authenticated')} }, status: 401
    end
  end
end

