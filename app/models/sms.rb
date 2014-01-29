require 'twilio-ruby'

class Sms
  include ApplicationHelper
  attr_accessor :send_to, :msg, :send_from

  def initialize send_to, msg
    @send_to = who_to_send send_to
    @msg = msg
    @send_from = "+15736147427"
  end


  def deliver
    # put your own credentials here
    # account_sid = 'ACad62729938ab760ec8e723e090553dbf'
    account_sid = 'AC32d59eb259a02e9b1f4b88f791cace9a'
    # auth_token = 'b94b4dfaec50c47a8acda1b8151db75a'
    auth_token = '58c70a50ec898f4fa32a00f2514a3ea1'
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
      Rails.logger.info "=============== DEBUG TWILIO START ================"
      Rails.logger.error "Twilio REST Error:  #{e.message}"
      Rails.logger.info "================ DEBUG TWILIO END ================="
      return [false, e.message]
    end
  end

  def who_to_send send_to
    if send_to[1..2] == get_settings_value(:dev_prefix, "99")
      return get_settings_value(:dev_phones)[send_to[3].to_i]
    else
      return send_to
    end
  end

end