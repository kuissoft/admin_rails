class Realtime
  def initialize
    @config = RockConfig.for "sockets"
  end

  def host
    ENV["API_NODE_URL"] || @config.host
  end

  def notify(user_id, event, data)
    RestClient.post(host + "/notify", { user_id: user_id, event: event, data: data })
  end
end
