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

  def accept
    # Since the other user is accepting, we search for a contact where user_id
    # is the contact_id from the other user's perspective
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first

    ActiveRecord::Base.transaction do
      connection.update_attribute(:is_pending, false)
      current_user.connections.create!(user_id: current_user.id, contact_id: params[:contact_id], is_pending: false)
    end

    ContactNotifications.status_changed(connection)

    render json: {}, status: 200
  end

  def decline
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first
    connection.update_attributes(is_pending: false, is_rejected: true)

    ContactNotifications.status_changed(connection)

    render json: {}, status: 200
  end

  private

  def contact_params
    params.require(:contact).permit(:contact_id, :nickname)
  end
end
