class Device < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :user

  validates_presence_of :uuid
  validates_uniqueness_of :uuid
  validates_uniqueness_of :apns_token, allow_nil: true, allow_blank: true

  before_save :ensure_authentication_token
  before_validation :ensure_apns_token_is_unique!

  # Delete all devices except mine
  def ensure_apns_token_is_unique!
    unless apns_token.blank?
      devices = Device.where("id != ? AND apns_token = ?", id, apns_token)
      devices.destroy_all if devices.any?
    end
  end


  def send_sms_or_email user
    if allow_to_send?(user)
      lang = language
      lang = 'en' unless language == 'cs' or language == 'sk'

      msg = ::I18n.t('sms.verification', code: verification_code, locale: lang)

      if Rails.env == 'development' or (user and user.admin? and get_settings_value(:force_sms) != "1")
        Emailer.authentication_email(user, self).deliver
        sms = [true, nil]
      else
        sms = Sms.new(phone, msg).deliver
      end
    else
      sms = [false, ::I18n.t('errors.sms_limit')]
    end
    sms
  end

  def allow_to_send? user
    allow = true
    if user.sms_count == 10 and Time.new < user.created_at + 30.days
      allow = false
    elsif user.sms_count == 10 and Time.new > user.created_at + 30.days
      user.update sms_count: 0, created_at: Time.now
      allow = true
    end
    allow
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
