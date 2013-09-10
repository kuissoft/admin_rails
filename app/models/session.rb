class Session < ActiveRecord::Base
  belongs_to :sender, class_name: 'User', inverse_of: :sender_session
  belongs_to :recipient, class_name: 'User', inverse_of: :recipient_session
  has_one :location, dependent: :destroy

  validates :sender, presence: true
  validates :recipient, presence: true

  scope :sorted, -> { order("created_at DESC") }
  scope :sorted_by_id, -> { order("id ASC") }

  validate :recipient_not_sender
  validate :sender_availability
  validate :recipient_availability

  def recipient_not_sender
    errors.add(:recipient, "has to be someone else") if sender != nil && sender == recipient
  end

  def sender_availability
    if Session.exists? ["sender_id = ? OR recipient_id = ?", sender.id, sender.id]
      errors.add(:sender, "is not available")
    end
  end

  def recipient_availability
    if Session.exists? ["sender_id = ? OR recipient_id = ?", recipient.id, recipient.id]
      errors.add(:recipient, "is not available")
    end
  end

  # Creates OpenTok session with determined server location and P2P enabled.
  def self.createSession(location)
    openTok = OpenTok::OpenTokSDK.new OPENTOK_API_KEY, OPENTOK_API_SECRET
    properties = {OpenTok::SessionPropertyConstants::P2P_PREFERENCE => "enabled"}
    return openTok.createSession :location => location, :properties => properties
  end

  # Generates OpenTok token using OpenTok session ID and adding custom data.
  def self.generateToken(session_id, connection_data)
    openTok = OpenTok::OpenTokSDK.new OPENTOK_API_KEY, OPENTOK_API_SECRET
    return openTok.generateToken :session_id => session_id, :connection_data => connection_data
  end
end
