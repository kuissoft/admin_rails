require 'twilio-ruby'

class Sms
  include ApplicationHelper
  attr_accessor :send_to, :msg, :send_from, :lang

  def initialize send_to, msg, lang = 'en'
    @send_to = send_to
    @msg = msg
    @send_from = get_settings_value(:twillio_sms_number) 
    @lang = lang
  end


  def deliver
    # put your own credentials here
    account_sid = get_settings_value(:twillio_account_sid) 
    auth_token = get_settings_value(:twillio_auth_token) 
    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    begin
      @client.account.messages.create(
      :from => @send_from,
      :to => @send_to,
      :body => @msg
      )
      return [true, nil]
    rescue Twilio::REST::RequestError => e
      Rails.logger.error "Twilio REST Error:  #{e.message}"
      return [false, ::I18n.t('errors.sms_cannot_send', locale: @lang)]
    end
  end

end