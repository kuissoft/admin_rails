class ActivityMonitorController < AuthenticatedController

  skip_before_filter :authenticate_user!, only: :refresh_logs
  require 'open-uri'
  respond_to :json
  def index
    rails_log = File.join(Rails.root, "log", "remote_assistant.log")
    rails_lines = `tail -100 #{ rails_log }`.split(/\n/)

    node_log = File.join(NODE_LOG, "logs", "app.log")
    node_lines = `tail -100 #{ node_log }`.split(/\n/)

    @lines = merge_lines(rails_lines, node_lines)
  end

  def refresh_logs
    rails_log = File.join(Rails.root, "log", "remote_assistant.log")
    rails_lines = `tail -100 #{ rails_log }`.split(/\n/)

    node_log = File.join(NODE_LOG, "logs", "app.log")
    node_lines = `tail -100 #{ node_log }`.split(/\n/)

    @lines = merge_lines(rails_lines, node_lines)

    respond_with @lines
  end

  def merge_lines rails, node, time = 10

    logs = []
    rails.each do |r|

      split_r = r.split("|||")
      logs << HashWithIndifferentAccess.new({level: split_r[1], timestamp: split_r[0], message: split_r[2], type: 'rails'})
    end

    node.each do |n|
      logs << HashWithIndifferentAccess.new(ActiveSupport::JSON.decode(n)) rescue ""
    end
    time_past = Time.now - time.minutes

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

