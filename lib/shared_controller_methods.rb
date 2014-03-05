module SharedControllerMethods
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

  # Universal destroyer for WEB API
  def api_destroy params
    begin
      @deletor = ActiveSupport::JSON.decode(connect_api(params[:model], params[:id]))['success']
    rescue => e
      logger.error "Error: #{e.inspect}"
    end
  end
end