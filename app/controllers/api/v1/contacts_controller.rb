require 'digest/sha1'
class Api::V1::ContactsController < Api::V1::AuthenticatedController
  respond_to :json
  around_action :wrap_transaction

  def index
    render json: current_user.connections, each_serializer: ContactSerializer
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

  # User unvites registered or not registered users
  # If user is not registered than new user is created and new connection with new user is created
  # If user exists than only new connection is created
  # 
  def invite
    phone = "+#{params[:contact][:phone]}"
    # Check if inveted user exists
    invited_user = User.where(phone: phone).first
    
    # If invited user not exits than create new one
    invited_user = User.create!(phone: phone, password: 'asdfasdf', validation_code: SecureRandom.hex(2)) unless invited_user

    # Find if connection between users exists
    conn = Connection.where(user_id: current_user, contact_id: invited_user).first

    # if connection not exits
    unless conn
      # Build new connection with invited user id
      connection = current_user.connections.build(contact_params)
      connection.contact_id = invited_user.id

      if connection.save 
        #ContactNotifications.added(connection)
        msg = "Hi! #{current_user.name} invites you to connect with him via Remote Assistant."
        sms = Sms.new(invited_user.phone, msg).deliver
        # Emailer.invitation_email(invited_user, current_user).deliver
        render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name , "phone" => invited_user.phone, "nickname" => connection.nickname}}, status: 200
      else
        render json: { error: { code: 101, message: connection.errors } }, status: 400
      end
    else
      render json: { error: { code: 108 }  }, status: 400 
    end
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
    params.require(:contact).permit(:contact_id, :nickname)
  end
end
