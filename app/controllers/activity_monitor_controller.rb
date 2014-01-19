class ActivityMonitorController < AuthenticatedController
  require 'open-uri'
  def index
    @logs = open('http://localhost:4000/development.log').read
     
  end

  def refresh_logs
    @logs = open('http://localhost:4000/development.log').read
    respond_to do |format|
      format.js
    end
  end
end
