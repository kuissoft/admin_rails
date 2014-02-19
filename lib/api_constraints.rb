class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    return true if @default
    return req.headers['Accept'].include?("application/vnd.remoteassistant.v#{@version}") if req.headers['Accept']
  end
end