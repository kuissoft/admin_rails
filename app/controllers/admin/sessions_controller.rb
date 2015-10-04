class Admin::SessionsController < ApplicationController
  def new
    render :new, :layout => false
  end

  def create
    user = User.find_by_email(user_params[:email])
    if user && BCrypt::Engine.hash_secret(params[:password], user.encrypted_password) == user.encrypted_password && user.admin?
      sign_in(user, store: true)
      redirect_to root_path, notice: "You were signed in"
    else
      flash.now[:error] = "Invalid credentials" + " " + BCrypt::Engine.hash_secret(params[:password], user.encrypted_password) + " -- " + user.encrypted_password + " -- " + user.valid_password?(user_params[:password]).to_s
      render :new, :layout => false
    end
  end

  def destroy
    sign_out current_user
    redirect_to new_user_session_path, notice: "You were signed out"
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
