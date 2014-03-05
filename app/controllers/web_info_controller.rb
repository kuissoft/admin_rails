class WebInfoController < AuthenticatedController
  def index
    begin
      @signups = ActiveSupport::JSON.decode(connect_api('signups'))['signups']
    rescue => e
      logger.error "Error: #{e.inspect}"
    end
  end

  def destroy
    api_destroy params
  end
end
