class ActivityMonitorController < AuthenticatedController
  require 'open-uri'
  def index
    @logs = []
    open("#{NODE_HOST}/development.log").each_line{|line| @logs <<  ActiveSupport::JSON.decode(line) rescue ""}
  end

  def refresh_logs
    @logs = []
    open("#{NODE_HOST}/development.log").each_line{|line| @logs <<  ActiveSupport::JSON.decode(line) rescue ""}
    respond_to do |format|
      format.js
    end
  end
end
