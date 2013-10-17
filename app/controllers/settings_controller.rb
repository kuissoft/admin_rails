class SettingsController < AuthenticatedController
  def index
    @settings = Settings.default_settings
  end

  def update
    Settings.default_settings.update_attributes(settings_params)
    redirect_to settings_path, notice: "Settings were updated."
  end

  private

  def settings_params
    params.require(:settings).permit(:token_expiration_period)
  end
end
