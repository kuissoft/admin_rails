class DevicesController < ApplicationController
  def index
    @devices = Device.all

  end

  def reset_sms
    device = Device.find(params[:id])
    device.reset_sms!
    redirect_to :back
  end
end
