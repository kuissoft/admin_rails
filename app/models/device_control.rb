class DeviceControl < ActiveRecord::Base
  def reset_sms!
    self.sms_count = 0
    save
  end
end
