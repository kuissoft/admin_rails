class TokensController < ApplicationController
  before_action :set_token, only: [:show, :edit, :update, :destroy]

  # GET /tokens
  # GET /tokens.json
  def index
    @tokens = Token.all
  end

  # GET /tokens/1
  # GET /tokens/1.json
  def show
  end

  # GET /tokens/new
  def new
    @token = Token.new
  end

  # GET /tokens/1/edit
  # def edit
  # end

  # POST /tokens
  # POST /tokens.json
  def create
    @token = Token.new(token_params)
    
    # if no session is specified, create and assign a new session
    if !@token.session
      @session = Session.new
      @session.session_id = Session.createSession(request.remote_addr).to_s
      # if valid, session will be saved autimaticaly upon assignment
      @token.session = @session if @session.valid?
    end
    
    # if the session was not created and assigned successfully, do not generate a token
    if (@token.session)
      # generate OpenTok token using OpenTok session ID and passing user ID as custom data
      @token.token_id = Token.generateToken(@token.session.session_id, @token.user_id.to_s)
    end

    respond_to do |format|
      if @token.save
        format.html { redirect_to @token, notice: 'Token was successfully created.' }
        format.json { render action: 'show', status: :created, location: @token }
      else
        format.html { render action: 'new' }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tokens/1
  # PATCH/PUT /tokens/1.json
  # def update
  #   respond_to do |format|
  #     if @token.update(token_params)
  #       format.html { redirect_to @token, notice: 'Token was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @token.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /tokens/1
  # DELETE /tokens/1.json
  def destroy
    @token.destroy
    respond_to do |format|
      format.html { redirect_to tokens_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_token
      @token = Token.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def token_params
      params.require(:token).permit(:token_id, :user_id, :session_id)
    end
end
