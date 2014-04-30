if LogStasher.enabled
  LogStasher.add_custom_fields do |fields|
    fields[:user] = current_user && current_user.phone
    fields[:site] = request.path =~ /^\/api/ ? 'api' : 'admin'
    #fields.except!(:route)
  end
end

class Rails::Rack::Logger
  def call_app(*args)
    puts "\n\n"+args.join(" ... ")+"\n\n"
    puts "\n\n"+args[1].to_a.join(" ... ")+"\n\n"
    path = args[1]['REQUEST_PATH']
    get = args[1]['QUERY_STRING']
    post = args[1]['rack.request.form_vars']
    time = DateTime.now.strftime("%Y-%m-%d %H:%M:%S.")
    severity = 'debug'
    puts "\n#{path} ||| #{time} ||| #{severity}"
    log_to_node(time, severity, "Path #{path} with #{get}&#{post} loaded") if path =~ /^\/api/
    env = args.last
    @app.call(env)
  ensure
    ActiveSupport::LogSubscriber.flush_all!
  end

  def before_dispatch(env)
  end

  def log_to_node(time, severity, msg)
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
      request.execute unless msg.empty?
    rescue => e
      puts "rescued"
    end
  end
end
