class WebInfoController < AuthenticatedController
  def index
    begin
      @feedbacks = ActiveSupport::JSON.decode(connect_api('feedbacks'))['feedbacks']
      @signups = ActiveSupport::JSON.decode(connect_api('signups'))['signups']
    rescue => e
      logger.error "Error: #{e.inspect}"
    end
  end

  def destroy
    begin
      @deletor = ActiveSupport::JSON.decode(connect_api(params[:model], params[:id]))['success']
    rescue => e
      logger.error "Error: #{e.inspect}"
    end
    redirect_to :back
  end

  ## Connect to WEB api for data
  def connect_api model, model_id = ""
    uri = URI("#{API_HOST}#{model}/#{model_id}")

    if model_id.present?
      req = Net::HTTP::Delete.new(uri)
    else
      req = Net::HTTP::Get.new(uri)
    end
    req.basic_auth API_NAME, API_PASSWORD

    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    res.body
  end
end
