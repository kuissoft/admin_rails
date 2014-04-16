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
    response = request.execute
    Rails.logger.debug '==========START DEBUG============'
    Rails.logger.debug "#{response.inspect}"
    Rails.logger.debug '===========END DEBUG============='
    response
    # RestClient.post(host + "/notify", {user_id: user_id, event: event, data: data })
  end
end
