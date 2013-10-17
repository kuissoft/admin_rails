class Settings < ActiveRecord::Base
  def self.default_settings
    Settings.first || Settings.create!(token_expiration_period: 5.minutes)
  end

  def self.token_expiration_period
    default_settings.token_expiration_period
  end
end
