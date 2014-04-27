class Device < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :uuid
  validates_uniqueness_of :uuid

  before_save :ensure_authentication_token

  def reset_sms!
    self.sms_count = 0
    self.reset_count = reset_count + 1
    save
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
