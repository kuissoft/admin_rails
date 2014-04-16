class ActivityMonitorController < AuthenticatedController

  skip_before_filter :authenticate_user!, only: :refresh_logs
  require 'open-uri'
  respond_to :json
  def index
    
    @lines = []
  end

  RAILS_LINES_CACHE = []


  def new_rails_lines time

    if RAILS_LINES_CACHE.size == 0

      rails_log = File.join(Rails.root, "log", "remote_assistant.log")
      rails_last_line = `tail -1 #{ rails_log }`
      
      rails_last_line_parts = rails_last_line.split("|||")
      

      while 


      end

    end

    

  end

  def refresh_logs
    
    new_rails_lines = new_rails_lines(params[:t0])

    node_log = File.join(NODE_LOG, "logs", "app.log")
    node_lines = `tail -100 #{ node_log }`.split(/\n/)
    
    
    @lines = merge_lines(rails_lines, node_lines, params[:t0])

    respond_with @lines
  end

  def merge_lines rails, node, time = 10
    puts time
    logs = []
    rails.each do |r|

      split_r = r.split("|||")
      logs << HashWithIndifferentAccess.new({level: split_r[1], timestamp: split_r[0], message: split_r[2], type: 'rails'})
    end

    node.each do |n|
      logs << HashWithIndifferentAccess.new(ActiveSupport::JSON.decode(n)) rescue ""
    end
    time_past = time.to_time

    logs.each_with_index do |l, index|

      if l[:level].nil?
        l[:timestamp] = logs[index-1][:timestamp]
        l[:level] = logs[index-1][:level]
        l[:message] = l[:timestamp]
      else
        logs.delete_at(index) if l[:timestamp].to_time < time_past
      end

    end

    merged_logs = logs.sort_by {|k| k[:timestamp].to_time}


    merged_logs.each do |l|
      l[:timestamp] = l[:timestamp].to_time.in_time_zone(Time.zone).to_formatted_s(:log)
    end
    merged_logs
  end
end

