if LogStasher.enabled
  LogStasher.add_custom_fields do |fields|
    fields[:user] = current_user && current_user.phone
    fields[:response] = response.body
    fields[:request] = params.to_s
    fields[:site] = request.path =~ /^\/api/ ? 'api' : 'admin'
    #fields.except!(:route)
  end
end

# class Rails::Rack::Logger
#   def call_app(*args)
#     #puts "\n\n"+args.join(" ... ")+"\n\n"
#     #puts "\n\n"+args[1].to_a.join(" ... ")+"\n\n"
#     # path = args[1]['REQUEST_PATH']
#     # get = args[1]['QUERY_STRING']
#     # post = args[1]['rack.request.form_vars']
#     # time = DateTime.now.strftime("%Y-%m-%d %H:%M:%S.")
#     # severity = 'debug'
#     # puts "\n#{path} ||| #{time} ||| #{severity}"
#     # log_to_node(time, severity, "Path #{path} with #{get}&#{post} loaded") if path =~ /^\/api/
#     env = args.last
#     @app.call(env)
#   ensure
#     ActiveSupport::LogSubscriber.flush_all!
#   end

#   def before_dispatch(env)
#   end

#   # def log_to_node(time, severity, msg)
#   #   request = RestClient::Request.new(
#   #     method: :post,
#   #     url: NODE_HOST + "/log_from_rails",
#   #     user: 'remote',
#   #     password: 'asdfasdf',
#   #     payload: {
#   #       time: time,
#   #       severity: severity,
#   #       msg: msg
#   #   })
#   #   begin
#   #     request.execute unless msg.empty?
#   #   rescue => e
#   #     puts "rescued"
#   #   end
#   # end
# end

class LogStasher::RequestLogSubscriber < ActiveSupport::LogSubscriber
  def process_action(event)
    payload = event.payload

    data = extract_request(payload)
    data.merge! extract_status(payload)
    data.merge! runtimes(event)
    data.merge! location(event)
    data.merge! extract_exception(payload)
    data.merge! extract_custom_fields(payload)

    #puts "\n\n"+data.to_a.inspect+"\n\n"
    time = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
    msg = "#{data[:method]} Path #{data[:path]} with #{data[:request]} . Response: #{data[:response]} with status #{data[:status]}."
    #puts "\n\n#{time} > #{msg}\n\n"
    log_to_node(time, 'debug', msg) if data[:path] =~ /^\/api/

    tags = ['request']
    tags.push('exception') if payload[:exception]
    event = LogStash::Event.new('@source' => LogStasher.source, '@fields' => data, '@tags' => tags)

    LogStasher.logger << event.to_json + "\n"
  end

  def log_to_node(time, severity, msg)
    request = RestClient::Request.new(
      method: :post,
      url: NODE_HOST + "/log_from_rails",
      user: NODE_ACCESS_NAME,
      password: NODE_ACCESS_PASSWORD,
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