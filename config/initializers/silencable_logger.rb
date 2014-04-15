NullLogger = Logger.new('/dev/null')

Rails::Rack::Logger.class_eval do
  def call_with_silenced_logger(env = {})
    silence = (
      env['QUERY_STRING'] =~ %r[silence=logger]iomx ||
      env['PATH_INFO'] =~ %r[(^/assets\b)|(^/su/logs\b)]iomx
    )

    if silence
      begin
        a = Rails.logger
        b = ActionController::Base.logger
        Rails.logger = NullLogger
        ActionController::Base.logger =  NullLogger
        call_without_silenced_logger(env)
      ensure
        Rails.logger = a
        ActionController::Base.logger = b
      end
    else
      call_without_silenced_logger(env)
    end
  end

  alias_method_chain(:call, :silenced_logger)
end

Rails.application.assets.logger = NullLogger
