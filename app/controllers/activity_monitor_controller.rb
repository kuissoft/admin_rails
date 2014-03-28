class ActivityMonitorController < AuthenticatedController
  require 'open-uri'
  def index
    # @logs = []
    # begin
    #   open("#{NODE_HOST}/log", :http_basic_authentication=>[NODE_ACCESS_NAME, NODE_ACCESS_PASSWORD]).each_line{|line| @logs <<  ActiveSupport::JSON.decode(line) rescue ""}
    # rescue
    #   @logs << {'timestamp' => Time.now, 'level' => "info", 'message' => 'NODE SERVER IS OFFLINE', }
    # end
  end

  def refresh_logs
    # @logs = []
    # begin
    #   open("#{NODE_HOST}/log", :http_basic_authentication=>[NODE_ACCESS_NAME, NODE_ACCESS_PASSWORD]).each_line{|line| @logs <<  ActiveSupport::JSON.decode(line) rescue ""}
    # rescue
    #   @logs << {'timestamp' => Time.now, 'level' => "info", 'message' => 'NODE SERVER IS OFFLINE'}
    # end
    # respond_to do |format|
    #   format.js
    # end
  end
end