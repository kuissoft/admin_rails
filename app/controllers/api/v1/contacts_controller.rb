require 'digest/sha1'
class Api::V1::ContactsController < Api::V1::AuthenticatedController
  respond_to :json
  around_action :wrap_transaction

  def index
    render json: current_user.connections.where("is_rejected = ? AND is_removed = ? ", false, false), each_serializer: ContactSerializer
  end

  def update
    connection = current_user.connections.where(contact_id: params[:id]).first
    contact = User.where(id: params[:id]).first
    if connection and contact
      if connection.update_attributes(contact_params)
        ContactNotifications.updated(connection)
        render json: {contact: {id: connection.contact_id, name: contact.name, email: contact.email, phone: contact.phone, is_pending: connection.is_pending, is_rejected: connection.is_rejected, is_removed: connection.is_removed, nickname: connection.nickname}}, status: 200
      else
        render json: { errors_info: {code: 101, title: '', messages: "#{connection.errors.full_messages.join(", ")}"} }, status: 400
      end
    else
      render json: { error_info: { code: 111, title: '', message: 'User not exists' } }, status: 401
    end
  end

  # User unvites registered or not registered users
  # If user is not registered than new user is created and new connection with new user is created
  # If user exists than only new connection is created
  #
  def invite
    phone = "+#{params[:contact][:phone]}".gsub(" ","")
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
      # Sending notification to cantact_id
      connection.contact_id = invited_user.id

      if connection.save
        send_sms_or_email(connection, current_user, invited_user)
        render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name , "phone" => invited_user.phone, "nickname" => connection.nickname}}, status: 200
      else
        render json: { error_info: { code: 101, title: '', message: connection.errors.full_messages.join(", ") } }, status: 400
      end
    else
      # If connection exists and it's pending send invitation msg agaim
      if conn.is_pending
        send_sms_or_email(conn, current_user, invited_user)
        render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name , "phone" => invited_user.phone, "nickname" => conn.nickname}}, status: 200
      else
        render json: { error_info: { code: 108, title: '', message: 'Connection already exists' }  }, status: 400
      end
    end
  end

  def send_sms_or_email connection, current_user, invited_user
    ContactNotifications.status_changed(connection, true)
    msg = "Hi! #{current_user.name} invites you to connect with him via Remote Assistant."
    unless invited_user.admin?
      sms = Sms.new(invited_user.phone, msg).deliver
    else
      Emailer.invitation_email(invited_user, current_user).deliver
    end
  end

  def accept
    # Since the other user is accepting, we search for a contact where user_id
    # is the contact_id from the other user's perspective
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first

    ContactNotifications.status_changed(connection)
    connection.update_attributes!(is_pending: false)
    begin
      current_user.connections.create!(user_id: current_user.id, contact_id: params[:contact_id], is_pending: false)

      render json: {}, status: 200
    rescue
      render json: { error_info: { code: 108, title: '', message: 'Connection already exists' }  }, status: 400
    end
  end

  def decline
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first

    connection.update_attributes!(is_pending: false, is_rejected: true)

    ContactNotifications.status_changed(connection)

    render json: {}, status: 200
  end

  def remove
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first
    begin
      connection.update_attributes!(is_removed: true)
      Connection.where(user_id: current_user.id, contact_id: params[:contact_id]).first.destroy

      ContactNotifications.status_changed(connection)

      render json: {}, status: 200
    rescue
      render json: { error_info: { code: 113, title: '', message: 'URL or Record not found' }  }, status: 500
    end
  end

  def dismiss
    connection = Connection.where(user_id: current_user.id, contact_id: params[:contact_id]).first
    connection.destroy if connection

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
