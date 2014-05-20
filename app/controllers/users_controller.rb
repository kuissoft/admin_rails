class UsersController < AuthenticatedController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :destroy_connection, :deauthenticate]
  before_action :set_connections, except: [:index, :new, :create, :reset_password, :photo, :reset_sms, :deauthenticate]
  before_action :set_devices, except: [:index, :new, :create, :reset_password, :photo, :reset_sms, :deauthenticate]

  # GET /users
  # GET /users.json
  def index
    @users = User.sorted
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.users_services.build
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def expire_token
    user = User.find(params[:id])
    user.assign_new_token
    redirect_to user, notice: "New token was generated"
  end

  # DELETE /connections/1
  # DELETE /connections/1.json
  def destroy_connection
    @connection = Connection.find(params[:conn_id])
    @connection.destroy
    respond_to do |format|
      format.html { redirect_to user_path(@user) }
    end
  end

  def reset_password
    user = User.find(params[:id])
    user.reset_password!
    redirect_to :back
  end

  def reset_sms
    user = User.find(params[:id])
    user.reset_sms!
    redirect_to :back
  end

  def deauthenticate
    if params[:all]
      Device.all.each do |device|
        device.update auth_token: nil
        Realtime.new.notify(@user.id, "device:deauthenticate", {uuid: device.uuid})
      end
      flash[:notice] = "All user's devices were deauthenticated"
    elsif params[:device_id]
      device = Device.where(id: params[:device_id]).first
      device.update auth_token: nil
      Realtime.new.notify(@user.id, "device:deauthenticate", {uuid: device.uuid})
      flash[:notice] = "User's device with id #{params[:id]} was deauthenticated"
    end
    redirect_to :back
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_connections
    @connections = User.where(id: @user.followers_uniq)
  end

  def set_devices
    @devices = @user.devices
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :role, :photo, :remove, :last_online_at, users_services_attributes: [:user_id, :service_id])
  end
end
