class Realtime
  def initialize
    @config = RockConfig.for "sockets"
  end

  def host
    NODE_HOST || @config.host
  end

  def notify(user_id, event, data)
    request = RestClient::Request.new(
      method: :post,
      url: host + "/notify",
      user: 'remote',
      password: 'asdfasdf',
      payload: {
        user_id: user_id,
        event: event,
        data: data
      })
    begin
      response = request.execute
      response
    rescue => e
      Rails.logger.error '==========START error============'
      Rails.logger.error "#{e.inspect}"
      Rails.logger.error '===========END DEBUG============='
      ""
  end
    # RestClient.post(host + "/notify", {user_id: user_id, event: event, data: data })
  end
end
