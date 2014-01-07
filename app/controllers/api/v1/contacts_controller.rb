require 'digest/sha1'
class Api::V1::ContactsController < Api::V1::AuthenticatedController
  respond_to :json
  around_action :wrap_transaction

  def index
    render json: current_user.connections, each_serializer: ContactSerializer
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

  def invite
    error = false
    invited_user = User.where(email: params[:contact][:email]).first
    
    hexmail = Digest::SHA1.hexdigest(params[:contact][:email])
    conn = Connection.where(token: hexmail).first

    unless conn
      if invited_user 
        conn = Connection.where(contact_id: invited_user.id).first
        unless conn
          connection = current_user.connections.build(contact_params)
          connection.contact_id = invited_user.id
        else
          error = true
        end
      else
        connection = current_user.connections.build(contact_params)
        connection.token = hexmail
      end
      if !error and connection.save 
        #ContactNotifications.added(connection)
        Emailer.invitation_email(params[:contact][:email], current_user).deliver
        render json: {success: true}, status: 200
      else
        render json: { error: connection.errors }, status: 400 if !error
      end
    else
      error = true 
    end
    render json: { error: 'Connection already exists' }, status: 400 if error
  end

  def accept
    # Since the other user is accepting, we search for a contact where user_id
    # is the contact_id from the other user's perspective
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first

    connection.update_attributes!(is_pending: false)
    current_user.connections.create!(user_id: current_user.id, contact_id: params[:contact_id], is_pending: false)

    ContactNotifications.status_changed(connection)

    render json: {}, status: 200
  end

  def decline
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first
    connection.update_attributes!(is_pending: false, is_rejected: true)

    ContactNotifications.status_changed(connection)

    render json: {}, status: 200
  end

  def remove
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first
    connection.update_attributes!(is_removed: true)

    Connection.where(user_id: current_user.id, contact_id: params[:contact_id]).first.destroy

    ContactNotifications.status_changed(connection)

    render json: {}, status: 200
  end

  private

  def wrap_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end

  def contact_params
    params.require(:contact).permit(:contact_id, :nickname, :token)
  end
end
