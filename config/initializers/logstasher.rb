if LogStasher.enabled
  LogStasher.add_custom_fields do |fields|
    fields[:user] = current_user && current_user.phone
    fields[:site] = request.path =~ /^\/api/ ? 'api' : 'admin'
    #fields.except!(:route)
  end
end

class Rails::Rack::Logger
  def call_app(*args)
    puts "Hello: #{args.inspect}"
    env = args.last
    @app.call(env)
  ensure
    ActiveSupport::LogSubscriber.flush_all!
  end

  def before_dispatch(env)
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
        request.execute unless msg.empty?
      end
    rescue => e
      puts "rescued"
    end
  end
end
