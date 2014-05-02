class Api::V2::AuthenticatedController < Api::V2::ApplicationController
  before_filter :authenticate_user_from_token!
  #before_filter :authenticate_user!


  private

  def authenticate_user_from_token!
    # Find device by combination user_id and device uuid
    @device = Device.where(user_id: params[:user_id], uuid: params[:uuid]).first

    if @device
      if params[:auth_token].present? and (@device.auth_token == params[:auth_token] or @device.last_token == params[:auth_token])
        sign_in @device.user, store: false
      else
        lang = @device.language
        lang = 'en' unless @device.language == 'cs' or @device.language == 'sk'
        render json: { error_info: { code: 102, title: '', message: t('errors.token_not_match', locale: lang)} }, status: 401
      end
    else
      render json: { error_info: { code: 104, title: '', message: t('errors.not_authenticated')} }, status: 401
    end
  end
end

