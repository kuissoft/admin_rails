class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_rapns_daemon

  private

  def check_rapns_daemon
    unless Rapns.config.embedded
      Thread.new do
        Rapns.embed
        Rapns.sync
        sleep 2
        Rapns.shutdown
      end
    end
  end
end
