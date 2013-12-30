class WebInfoController < ApplicationController
  def index
    begin
      @feedbacks = ActiveSupport::JSON.decode(connect_api('feedbacks'))['feedbacks']
      @signups = ActiveSupport::JSON.decode(connect_api('signups'))['signups']
    rescue => e
      logger.error "Error: #{e.inspect}"
    end
  end

  ## Connect to WEB api for data
  def connect_api model
    uri = URI("#{API_HOST}#{model}")

    req = Net::HTTP::Get.new(uri)
    req.basic_auth API_NAME, API_PASSWORD

    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    res.body
  end
end
