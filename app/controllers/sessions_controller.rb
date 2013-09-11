class SessionsController < AuthenticatedController
  before_action :set_session, only: [:show, :edit, :update, :destroy]

  # GET /sessions
  # GET /sessions.json
  def index
    @sessions = Session.all
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
  end

  # GET /sessions/new
  def new
    @session = Session.new
  end

  # GET /sessions/1/edit
  # def edit
  # end

  # POST /sessions
  # POST /sessions.json
  def create
    
    # remove any existing session of this user
    # TODO: update custom validations in model to work with this
    @session = Session.where("sender_id = #{session_params[:sender_id]} OR recipient_id = #{session_params[:sender_id]}").first
    @session.destroy if @session
    
    @session = Session.new(session_params)
    
    if @session.valid?
      @session.session_id = Session.createSession(request.remote_addr).to_s
      @session.sender_token = Session.generateToken(@session.session_id, @session.sender.id.to_s)
      @session.recipient_token = Session.generateToken(@session.session_id, @session.recipient.id.to_s)
    end

    respond_to do |format|
      if @session.save
        format.html { redirect_to @session, notice: 'Session was successfully created.' }
        format.json { render action: 'show', status: :created, location: @session }
      else
        format.html { render action: 'new' }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sessions/1
  # PATCH/PUT /sessions/1.json
  # def update
  #   respond_to do |format|
  #     if @session.update(session_params)
  #       format.html { redirect_to @session, notice: 'Session was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @session.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    @session.destroy
    respond_to do |format|
      format.html { redirect_to sessions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def session_params
      # TODO: session_id should be only there for some existions, why for create ? separate !
      params.require(:session).permit(:session_id, :sender_id, :recipient_id)
    end
end
