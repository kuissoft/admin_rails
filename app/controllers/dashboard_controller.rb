class DashboardController < ApplicationController

  # GET /users
  # GET /users.json
  def index
    if params[:type_filter] == nil || params[:type_filter] == "all"
      @records = Record.all
    elsif params[:type_filter] == "user"
      users_ids = []
      for u in User.all
        if u.role == "user"
          users_ids << u.id
        end
      end
      @records = Record.where(assistant_id: users_ids)
    else
      operators_ids = []
      for u in User.all
        if u.role == "operator"
          if u.users_services.where(service_id: params[:type_filter]).count > 0
            operators_ids << u.id
          end
        end
      end
      @records = Record.where(assistant_id: operators_ids)
    end
    
    now = Time.now.utc
    today = DateTime.now.at_beginning_of_day.utc
    
    case params[:date_filter]      
    when "today"
      @records = @records.where(created_at: today..now)
    when "yesterday"
      @records = @records.where(created_at: (today-24.hours)..today)
    when "7-days"
      @records = @records.where(created_at: (now-7.days)..now)
    when "30-days"
      @records = @records.where(created_at: (now-30.days)..now)
    when "60-days"
      @records = @records.where(created_at: (now-60.days)..now)
    when "90-days"
      @records = @records.where(created_at: (now-90.days)..now)
    else # all
      # do not filter based on date
    end
    
    case params[:days_filter]      
    when "workdays"
      @records = @records.where("EXTRACT(DOW FROM created_at) >= 1 AND EXTRACT(DOW FROM created_at) <= 5")
    when "weekend"
      @records = @records.where("EXTRACT(DOW FROM created_at) = 0 AND EXTRACT(DOW FROM created_at) = 6")
    else # all
      # do not filter based on day
    end
    
    @answered_records = []
    @answered_records_percent = 0
    @redirect_records_count = 0
    @timeout_records_count = 0
    @failed_records_count = 0
    @average_call_length = 0
    @unique_callers_count = 0
    @operators_calls = []
    
    if @records.count > 0

      @answered_records = @records.where(ended_by: 1..2)
      @answered_records_percent = (@answered_records.count.to_f/@records.count.to_f*100).to_i
      @redirect_records_count = @records.where(ended_by: 3).count
      @timeout_records_count = @records.where(ended_by: 4).count
      @failed_records_count = @records.where("ended_by IS NULL OR ended_by = 0 OR ended_by = 5").count

      if @answered_records.count > 0
        @average_call_length = 0
        @total_call_length = 0
        for record in @answered_records
          if record.accepted_at
            @total_call_length += (record.ended_at - record.accepted_at).to_i
          end
        end
        @average_call_length = (@total_call_length/@answered_records.count).to_i
      else
        @average_call_length = 0
      end

      @unique_callers_count = @records.select(:caller_id).uniq.count
      @unique_assistants = @records.select(:assistant_id).uniq

      assistant_ids = []
      for record in @records
        if record.assistant_id
          assistant_ids << record.assistant_id if !assistant_ids.include?(record.assistant_id)
        end
      end
      for assistant_id in assistant_ids
        assistant = User.find_by_id(assistant_id)
        assistant_name = assistant_id.to_s
        if assistant
          assistant_name = assistant.name
        end
        @operators_calls << [assistant_name,@records.where(assistant_id: assistant_id).count]
      end
    end
    
    Record.destroy_all(assistant_id: 25)
  end

  # def twilio
  #   require 'twilio-ruby'
  #   account_sid = get_settings_value(:twillio_account_sid)
  #   auth_token = get_settings_value(:twillio_auth_token)
  #   @client = Twilio::REST::Client.new account_sid, auth_token
  #   respond_to do |format|
  #     format.js
  #   end
  # end
end
