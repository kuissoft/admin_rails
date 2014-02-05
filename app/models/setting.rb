class Setting < ActiveRecord::Base


  def self.token_expiration_period
    default_settings.token_expiration_period
  end
end
