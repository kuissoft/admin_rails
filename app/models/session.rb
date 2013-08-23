class Session < ActiveRecord::Base
  has_many :tokens, dependent: :destroy
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  
  validates :session_id,
    presence: true # session ID has to be set
    
  default_scope :order => "created_at DESC"
  
  # Creates OpenTok session with determined server location and P2P enabled.
  def self.createSession(location)
    openTok = OpenTok::OpenTokSDK.new OPENTOK_API_KEY, OPENTOK_API_SECRET
    properties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}
    return openTok.createSession :location => location, :properties => properties
  end
end
