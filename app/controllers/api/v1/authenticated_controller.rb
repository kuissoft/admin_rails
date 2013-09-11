class Api::V1::AuthenticatedController < Api::V1::ApplicationController
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  private

  def authenticate_user_from_token!
    user = User.find_by_authentication_token(params[:auth_token])

    if user
      sign_in user, store: false
    end
  end
end
