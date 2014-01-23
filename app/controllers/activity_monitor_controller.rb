class ActivityMonitorController < AuthenticatedController
  require 'open-uri'
  def index
    @logs = []
    open("#{NODE_HOST}/development.log", :http_basic_authentication=>[NODE_ACCESS_NAME, NODE_ACCESS_PASSWORD]).each_line{|line| @logs <<  ActiveSupport::JSON.decode(line) rescue ""}
  end

  def refresh_logs
    @logs = []
    open("#{NODE_HOST}/development.log", :http_basic_authentication=>[NODE_ACCESS_NAME, NODE_ACCESS_PASSWORD]).each_line{|line| @logs <<  ActiveSupport::JSON.decode(line) rescue ""}
    respond_to do |format|
      format.js
    end
  end
end