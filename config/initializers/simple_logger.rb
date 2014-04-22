class ActiveSupport::Logger::SimpleFormatter
  SEVERITY_TO_TAG_MAP     = {'DEBUG'=>'debug', 'INFO'=>'info', 'WARN'=>'warn', 'ERROR'=>'error', 'FATAL'=>'fatal', 'UNKNOWN'=>'unknown'}
  SEVERITY_TO_COLOR_MAP   = {'DEBUG'=>'0;37', 'INFO'=>'32', 'WARN'=>'33', 'ERROR'=>'31', 'FATAL'=>'31', 'UNKNOWN'=>'37'}
  USE_HUMOROUS_SEVERITIES = false

  @@cnt = 0

  def call(severity, time, progname, msg)

    if USE_HUMOROUS_SEVERITIES
      formatted_severity = sprintf("%-3s",SEVERITY_TO_TAG_MAP[severity])
    else
      formatted_severity = sprintf("%-5s",severity)
    end

    formatted_time = time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)
    color = SEVERITY_TO_COLOR_MAP[severity]
    foramtted_msg = msg.strip.gsub('\n','')

    log_to_node(formatted_time, severity, foramtted_msg)
    "#{formatted_time}|||#{severity}|||#{foramtted_msg}\n" #unless formatted_severity == "DEBUG"
  end

  def log_to_node(time, severity, msg)

    @@cnt += 1

    request = RestClient::Request.new(
      method: :post,
      url: NODE_HOST + "/log_from_rails",
      user: 'remote',
      password: 'asdfasdf',
      payload: {
        time: time,
        severity: severity,
        msg: msg
    })
    begin
      if @@cnt == 2
        @@cnt = 0
      else
        request.execute
      end

    rescue => e
      puts "rescued"
    end
  end


end

