class Api::V1::SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  respond_to :json

  # TODO: temporary for demo
  def index
    puts '----------------------------------'
    puts '--- sessions / index -------------'
    puts '----------------------------------'

    # TODO: are params enough ? session_params ? create specific for index
    if params[:session][:sender_id]

      @session = Session.where(sender_id: params[:session][:recipient_id]).first
      if @session
        respond_with @session, :except => [:sender_id, :sender_token, :created_at, :updated_at]
      else
        render :json => { :message => "Session not found." }, :status => 404 # not found
      end
    elsif params[:session][:recipient_id]
      @session = Session.where(recipient_id: params[:session][:recipient_id]).first
      if @session
        respond_with @session, :except => [:sender_id, :sender_token, :created_at, :updated_at]
      else
        render :json => { :message => "Session not found." }, :status => 404 # not found
      end
    else
      respond_with Session.sorted, :except => [:sender_id, :sender_token, :created_at, :updated_at]
    end 
  end

  # GET /sessions/1
  def show
    puts '----------------------------------'
    puts '--- sessions / show --------------'
    puts '----------------------------------'
  end

  # POST /sessions
  def create
    puts '----------------------------------'
    puts '--- sessions / create ------------'
    puts '----------------------------------'

    # remove any existing session of this user
    # TODO: update custom validations in model to work with this
    @session = Session.where("sender_id = #{session_params[:sender_id]} OR recipient_id = #{session_params[:sender_id]}").first
    @session.destroy if @session

    # TODO: check if sender is the user who is sending the request

    @session = Session.new(session_params)

    if @session.valid?
      @session.session_id = Session.createSession(request.remote_addr).to_s
      @session.sender_token = Session.generateToken(@session.session_id, @session.sender.id.to_s)
      @session.recipient_token = Session.generateToken(@session.session_id, @session.recipient.id.to_s)
    end

    if @session.save
      respond_with @session, :except => [:sender_id,:recipient_id, 
                                         :recipient_token, :created_at, :updated_at], status: :created
    else
      render json: @session.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sessions/1
  def destroy
    puts '----------------------------------'
    puts '--- sessions / destroy -----------'
    puts '----------------------------------'

    # TODO: is session_params needed here and everywhere else ?
    @session = Session.find(params[:id])
    if (@session.destroy)
      render :json => { :message => "Session deleted." }, :status => 200 # ok
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_session
    begin
      @session = Session.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render :json => {  :error => "Session not found." }, :status => 404 # not found
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
    params.require(:session).permit(:session_id, :sender_id, :recipient_id)
  end
end
