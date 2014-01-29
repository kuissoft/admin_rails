class SettingsController < AuthenticatedController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  def index
    @settings = Setting.order(:name)
  end

  def new
    @setting = Setting.new
  end

  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to settings_path, notice: 'Setting was successfully created.' }
        format.json { render action: 'show', status: :created, location: @setting }
      else
        format.html { render action: 'new' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to settings_path, notice: 'Settings was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.where(id: params[:id]).first
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
    params.require(:setting).permit(:name, :value)
  end
end
