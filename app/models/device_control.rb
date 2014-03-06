class DeviceControl < ActiveRecord::Base
  def reset_sms!
    self.sms_count = 0
    self.reset_count = reset_count + 1
    save
  end

  def user
    User.where(phone: phone).first || ""
  end
end
