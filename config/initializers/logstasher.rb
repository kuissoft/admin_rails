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
end
