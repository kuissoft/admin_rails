require 'twilio-ruby'

class Sms
  include ApplicationHelper
  attr_accessor :send_to, :msg, :send_from

  def initialize send_to, msg
    @send_to = send_to
    @msg = msg
    @send_from = get_settings_value(:twillio_sms_number) 
  end


  def deliver
    # put your own credentials here
    account_sid = get_settings_value(:twillio_account_sid) 
    auth_token = get_settings_value(:twillio_auth_token) 
    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token

    begin
      if (@send_to.length < 7 and @send_to.length > 15) and /\A(\+)?[0-9 ]+\z/.match(@send_to)
        return [false, ::I18n.t('errors.phone_not_valid')]
      else
        @client.account.messages.create(
        :from => @send_from,
        :to => @send_to,
        :body => @msg
        )
        return [true, nil]
      end
    rescue Twilio::REST::RequestError => e
      Rails.logger.info "=============== DEBUG TWILIO START ================"
      Rails.logger.error "Twilio REST Error:  #{e.message}"
      Rails.logger.info "================ DEBUG TWILIO END ================="
      return [false, ::I18n.t('errors.sms_cannot_send')]
    end
  end

end