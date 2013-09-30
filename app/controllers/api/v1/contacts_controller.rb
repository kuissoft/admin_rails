class Api::V1::ContactsController < Api::V1::AuthenticatedController
  respond_to :json

  def index
    render json: current_user.contacts
  end

  def create
    connection = current_user.connections.build(contact_params)
    if connection.save
      ContactNotifications.added(connection)
      render json: connection
    else
      render json: { errors: connection.errors }, status: 400
    end
  end

  def update
    connection = current_user.connections.find(params[:id])
    if connection.update_attributes(contact_params)
      ContactNotifications.updated(connection)
      render json: connection
    else
      render json: { errors: connection.errors }, status: 400
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:contact_id, :nickname)
  end
end
