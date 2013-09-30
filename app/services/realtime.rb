class Realtime
  def initialize
    @config = RockConfig.for "sockets"
  end

  def notify(user_id, event, data)
    RestClient.post(@config.host + "/notify", { user_id: user_id, event: event, data: data })
  end
end
