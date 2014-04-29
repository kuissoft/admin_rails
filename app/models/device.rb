class Device < ActiveRecord::Base
  belongs_to :user

  # validates_presence_of :uuid
  # validates_uniqueness_of :uuid
  # validates_uniqueness_of :token, allow_nil: true, allow_blank: true

  before_save :ensure_authentication_token
  #before_validation :ensure_apns_token_is_unique!

  # Delete all devices except mine
  def ensure_apns_token_is_unique!
    unless token.blank?
      devices = Device.where("id != ? AND token = ?", id, token)
      devices.destroy_all if devices.any?
    end
  end

  

  def ensure_authentication_token
    assign_new_token if auth_token.blank?
  end

  def assign_new_token
    self.last_token = self.auth_token
    self.auth_token = generate_authentication_token
    self.token_updated_at = Time.zone.now
    save!
  end

  def expired_token?
    (token_updated_at + Settings.token_expiration_period) < Time.zone.now
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Device.exists?(auth_token: token)
    end
  end
end
