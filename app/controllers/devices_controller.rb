class DevicesController < ApplicationController
  def index
    @devices = DeviceControl.all

  end

  def reset_sms
    device = DeviceControl.find(params[:id])
    device.reset_sms!
    redirect_to :back
  end
end
