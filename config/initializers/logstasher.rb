if LogStasher.enabled
  LogStasher.add_custom_fields do |fields|
    # This block is run in application_controller context,
    # so you have access to all controller methods
    fields[:user] = current_user && current_user.phone
    fields[:site] = request.path =~ /^\/api/ ? 'api' : 'admin'
    #fields.except!(:route)

    # If you are using custom instrumentation, just add it to logstasher custom fields
    #LogStasher.custom_fields << :myapi_runtime
  end
end

class Rails::Rack::Logger
 # Overwrites Rails 3.2 code that logs new requests
 def call_app(*args)
   puts "Hello: #{args.inspect}"
   env = args.last
   @app.call(env)
 ensure
   ActiveSupport::LogSubscriber.flush_all!
 end

 # Overwrites Rails 3.0/3.1 code that logs new requests
 def before_dispatch(env)
 end
end