require 'twilio-ruby'

class Sms

  attr_accessor :send_to, :msg, :send_from

  def initialize send_to, msg
    @send_to = send_to
    @msg = msg
    @send_from = "+14807257455"
  end


  def deliver
    # put your own credentials here
    # account_sid = 'ACad62729938ab760ec8e723e090553dbf'
    account_sid = 'ACe968116ee17d32bf317155d0caeb830b'
    # auth_token = 'b94b4dfaec50c47a8acda1b8151db75a'
    auth_token = 'd29e5113d746a1c16be01c76f7f397ab'
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

end