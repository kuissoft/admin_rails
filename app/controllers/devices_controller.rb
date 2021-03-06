class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  def index
    @devices = Device.all
  end

  def new
    @device = Device.new
  end

  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to devices_path, notice: 'Device was successfully created.' }
        format.json { render action: 'show', status: :created, location: @device }
      else
        format.html { render action: 'new' }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @device.update(device_params)
        if params[:return_to].present?
          format.html { redirect_to user_path(params[:return_to]), notice: 'Device was successfully updated.' }
        else
          format.html { redirect_to devices_path, notice: 'Device was successfully updated.' }
          format.json { head :no_content }
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @device.destroy
    respond_to do |format|
      if params[:return_to]
        format.html { redirect_to user_path(params[:return_to]), notice: 'Device was successfully deleted.' }
      else
        format.html { redirect_to devices_url }
        format.json { head :no_content }
      end
    end
  end





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.where(id: params[:id]).first
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
    params.require(:device).permit(:online, :uuid, :user_id, :phone, :language, :verification_code, :invalid_count, :sms_count, :reset_count, :resent, :resent_at, :apns_token, :auth_token, :last_token, :token_updated_at, :connection_type, :last_online_at )
  end
end
