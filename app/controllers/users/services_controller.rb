class Users::ServicesController < UsersController
  before_action :set_user, only: [:add_service, :remove_service]
  skip_before_action :set_connections, only: [:add_service, :remove_service]
  skip_before_action :set_devices, only: [:add_service, :remove_service]

  def add_service
    if @user.users_services.create(service_id: params[:service_id])
      flash[:notice] = "Service was successfuly added."
      redirect_to :back
    else
      flash[:error] = "Something went wong! Service not added!"
      redirect_to :back
    end
  end

  def remove_service
    if @user.services.destroy(params[:service_id])
      flash[:notice] = "Service was succesfuly removed"
      redirect_to :back
    else
      flash[:error] = "Something went wong! Service not removed!"
      redirect_to :back
    end
  end
end
