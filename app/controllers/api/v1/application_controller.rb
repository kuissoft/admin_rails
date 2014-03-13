class Api::V1::ApplicationController < ActionController::Base
  include ApplicationHelper
  def set_language_by_area_code phone
    lang = 'en'
    lang = 'cs' if phone[1..3] == "420"
    lang = 'sk' if phone[1..3] == "421"
    lang
  end
end
