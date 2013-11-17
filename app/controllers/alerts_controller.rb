class AlertsController < ApplicationController
  before_filter :load_alert, :only => [:show, :destroy]
  before_filter :add_breadcrumbs, :except => :destroy
  helper_method :sort_column, :sort_direction

  # GET /alerts
  # GET /alerts.json
  def index
    @alerts = Alert.order(sort_column + " " + sort_direction)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @alerts }
    end
  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @alert }
    end
  end

  # GET /alerts/new
  # GET /alerts/new.json
  def new
    @alert = Alert.new

    # NOTE: this should be in config/initializers/rapns.rb,
    # but the reflection does not work (this works fine)

    # destroy unregistered devices
    Rapns::Apns::Feedback.all.each do |feedback|
      Device.where(:token => feedback.device_token).destroy_all
    end

    # clear feedback
    Rapns::Apns::Feedback.destroy_all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @alert }
    end
  end

  # POST /alerts
  # POST /alerts.json
  def create
    @alert = Alert.new(params[:alert])

    # check message length
    n = Rapns::Apns::Notification.new
    n.alert = @alert.message
    if n.payload_size > 256
      overflow_bytesize = (n.payload_size - 256).to_s
      flash.now[:error] = 'Message is too long, please remove ' + overflow_bytesize + ' bytes of characters.'
      render action: "new"
      return
    end

    respond_to do |format|
      if @alert.save

        # send notifications
        Device.all.each do |device|
           n = Rapns::Apns::Notification.new
           n.app = Rapns::Apns::App.find_by_name("ios_app")
           n.device_token = device.token
           n.alert = @alert.message
           n.sound = "Calling.wav"
           n.save!
        end

        format.html { redirect_to @alert, notice: 'Alert was successfully created.' }
        format.json { render json: @alert, status: :created, location: @alert }
      else
        format.html { render action: "new" }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert.destroy

    respond_to do |format|
      format.html { redirect_to alerts_url }
      format.json { head :no_content }
    end
  end

  private

  def load_alert
    @alert = Alert.find(params[:id])
  end

  include ActionView::Helpers::TextHelper
  def add_breadcrumbs
    add_breadcrumb params[:controller].capitalize, alerts_path
    if ["new", "create"].include? params[:action]
      add_breadcrumb "New"
    elsif "show" == params[:action]
      add_breadcrumb truncate(@alert.message, :length => 30, :separator => ' '), alert_path
    end
  end

  def sort_column
    Alert.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end

