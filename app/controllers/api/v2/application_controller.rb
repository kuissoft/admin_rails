class Api::V2::ApplicationController < ActionController::Base
  def set_language_by_area_code phone
    lang = 'en'
    lang = 'cs' if phone[1..3] == "420"
    lang = 'sk' if phone[1..3] == "421"
    lang
  end
end
