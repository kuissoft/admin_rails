class Realtime
  def initialize
    @config = RockConfig.for "sockets"
  end

  def notify(user_id, event, data)

    request = RestClient::Request.new(
      method: :post,
      url: NODE_HOST + "/notify",
      user: NODE_ACCESS_NAME,
      password: NODE_ACCESS_PASSWORD,
      payload: {
        user_id: user_id,
        event: event,
        data: data
    })
    begin
      response = request.execute
      response
    rescue => e
      Rails.logger.error "Error when sending notifications: #{e.inspect}"
      ""
    end
  end

  def disconnect(user_id, uuid, contacts)

    request = RestClient::Request.new(
      method: :post,
      url: NODE_HOST + "/disconnect",
      user: NODE_ACCESS_NAME,
      password: NODE_ACCESS_PASSWORD,
      payload: {
        user_id: user_id,
        uuid: uuid,
        contacts: contacts,
        deauthenticate: true
    })
    begin
      request.execute
    rescue => e
      Rails.logger.error "Error when sending disconnect: #{e.inspect}"
      ""
    end
  end
end
