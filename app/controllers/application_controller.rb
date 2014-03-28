class ApplicationController < ActionController::Base
  skip_before_filter :verify_authenticity_token
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  include ApplicationHelper
  include SharedControllerMethods

  # CUSTOM EXCEPTION HANDLING
  rescue_from Exception do |e|
    error(e)
  end
 
  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end
 
  protected
  
  def error(e)
    #render :template => "#{Rails::root}/public/404.html"
    if env["ORIGINAL_FULLPATH"] =~ /^\/api/undefined_error
      logger.error "=============== DEBUG START ================"
      logger.error "Debug: #{e.inspect}"
      logger.error "================ DEBUG END ================="

    render json: { error_info: { code: 113, title: '', message: t('errors.url_or_record_not_found')} }, status: 500
    else
      logger.error "=============== DEBUG START ================"
      logger.error "Debug: #{e.inspect}"
      logger.error "================ DEBUG END ================="
      raise e
      render json: { error_info: { code: 100, title: '', message: t('errors.undefined_error')} }, status: 500
      #render :text => "500 Internal Server Error", :status => 500 # You can render your own template here
    end
  end
  
end
