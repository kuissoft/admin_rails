class Opentok
  attr_accessor :tokbox, :session_id, :caller_token, :assistant_token

  def initialize api_key, api_secret
    # Creating an OpenTok Object
    @tokbox = OpenTok::OpenTokSDK.new api_key, api_secret
    sessionProperties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}
    @session_id =  @tokbox.createSession( "127.0.0.1", sessionProperties ).to_s
    @caller_token = @tokbox.generateToken(session_id: @session_id)
    @assistant_token = @tokbox.generateToken(session_id: @session_id)
  end
end