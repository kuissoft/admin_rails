class Api::V2::ApplicationController < ActionController::Base
  before_action :set_language_from_headers
  include ApplicationHelper
  def set_language_by_area_code phone
    lang = 'en'
    lang = 'cs' if phone[1..3] == "420"
    lang = 'sk' if phone[1..3] == "421"
    lang
  end

  def ping
    render json: {}, status: 200
  end

  private
  def set_language_from_headers
    @language = http_accept_language.compatible_language_from(I18n.available_locales)
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end

end
