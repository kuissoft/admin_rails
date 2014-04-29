require 'digest/sha1'

class Api::V1::ContactsController < Api::V1::AuthenticatedController
  respond_to :json
  around_action :wrap_transaction

  def index
    if params[:only_ids]
      render json: {contacts: current_user.connections.where("is_rejected = ? AND is_removed = ? ", false, false).map(&:contact_id)}
    else
      render json: current_user.connections.where("is_rejected = ? AND is_removed = ? ", false, false), each_serializer: ContactSerializer
    end
  end

  def update
    connection = current_user.connections.where(contact_id: params[:id]).first
    contact = User.where(id: params[:id]).first

    if connection and contact
      if connection.update_attributes(contact_params)
        ContactNotifications.updated(connection)
        render json: {contact: {id: connection.contact_id, name: contact.name, email: contact.email, state: state(contact, connection.is_pending), phone: contact.phone, is_pending: connection.is_pending, is_rejected: connection.is_rejected, is_removed: connection.is_removed, nickname: connection.nickname}}, status: 200
      else
        render json: { errors_info: {code: 101, title: '', messages: "#{connection.errors.full_messages.join(", ")}"} }, status: 400
      end
    else
      Rails.logger.error " >>>>>>>>>>>>>>>>> COntact update WTF??? <<<<<<<<<<<<<"
      render json: { error_info: { code: 111, title: '', message: t('errors.user_not_exist') } }, status: 401
    end
  end

  def state user, is_pending
    contact_state = 'offline'
    if user
      if user.is_online? 
        contact_state = 'online'
      else
        contact_state = 'offline'
      end
    end
    contact_state = 'pending' if is_pending
    contact_state
  end

  # User unvites registered or not registered users
  # If user is not registered than new user is created and new connection with new user is created
  # If user exists than only new connection is created
  #
  def invite
    phone = "+#{params[:contact][:phone]}".gsub(" ","")
    # Check if inveted user exists
    invited_user = User.where(phone: phone).first
    device = Device.where(phone: phone, uuid: params[:uuid]).first

    # If invited user not exits than create new one
    invited_user = User.create!(phone: phone, password: 'asdfasdf') unless invited_user
    unless device
      device = Device.create!(phone: phone, uuid: params[:uuid], language: set_language_by_area_code(invited_user.phone), user_id: invited_user.id)
    else
      device.update  uuid: params[:uuid], user_id: invited_user.id, language: device.language
    end


    # Find if connection between users exists
    conn = Connection.where(user_id: current_user, contact_id: invited_user).first

    # if connection not exits
    unless conn
      # Build new connection with invited user id
      connection = current_user.connections.build(contact_params)
      connection.contact_id = invited_user.id

      # check if exist pending invitation from other side
      other_connection = Connection.where(user_id: invited_user, contact_id: current_user).first

      both_invited = false
      # if exists
      if other_connection
        # and is pending or is rejected is automaticaly accept invitation
        if other_connection.is_pending or other_connection.is_rejected
          other_connection.update is_pending: false, is_rejected: false, is_removed: false
          connection.is_pending = false
          connection.is_rejected = false
          connection.is_removed = false
          both_invited = true
        elsif other_connection.is_removed
          other_connection.destroy
          connection.is_pending = true
          connection.is_rejected = false
          connection.is_removed = false
        end
      end

      if connection.save
        unless both_invited
          send_sms_or_email(connection, current_user, invited_user, device)
          ContactNotifications.status_changed(connection, true)
          render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name , "phone" => invited_user.phone, "state" => 'pending', "nickname" => connection.nickname}}, status: 200   
        else
          ContactNotifications.status_changed(connection)
          ContactNotifications.status_changed(other_connection)
          render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name , "phone" => invited_user.phone, "state" => 'online', "nickname" => connection.nickname}}, status: 200  
        end
      else
        render json: { error_info: { code: 101, title: '', message: connection.errors.full_messages.join(", ") } }, status: 400
      end
    else
      # If connection exists and it's pending send invitation msg agaim
      if conn.is_pending
        send_sms_or_email(conn, current_user, invited_user, device)

        render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name, "state" => 'pending' , "phone" => invited_user.phone, "nickname" => conn.nickname}}, status: 200
        ContactNotifications.status_changed(conn, true)
      elsif conn.is_rejected or conn.is_removed
        # and if is rejected set connection to pending again 
        conn.update is_pending: true, is_rejected: false, is_removed: false
        render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name, "state" => 'pending' , "phone" => invited_user.phone, "nickname" => conn.nickname}}, status: 200
        ContactNotifications.status_changed(conn, true)
      else
        render json: { error_info: { code: 108, title: '', message: t('errors.connection_exists') }  }, status: 400
      end
    end
  end

  

  def send_sms_or_email connection, current_user, invited_user, device
    # Device for sms count
    allow_send = true
    if device
      if device.sms_count == 10 and Time.new < device.created_at + 30.days
        allow_send = false
      elsif device.sms_count == 10 and Time.new > device.created_at + 30.days
        device.update sms_count: 0, created_at: Time.now
        allow_send = true
      end
    else
      allow_send = false
    end

    if allow_send
      invited_user_device = Device.where(phone: invited_user.phone).first
      lang = set_language_by_area_code(invited_user.phone)
      if invited_user_device
        if invited_user_device.language == 'cs'
          lang = 'cs'
        elsif invited_user_device.language == 'sk'
          lang = 'sk'
        else
          lang = 'en'
        end
      end
      msg = t('sms.invitation', user: resolve_name(current_user), locale: lang )
      unless invited_user.admin? and get_settings_value(:force_sms) != "1" 
        sms = Sms.new(invited_user.phone, msg).deliver
      else
        begin
          Emailer.invitation_email(invited_user, current_user, device).deliver
        rescue => e
          logger.error "=============== DEBUG START ================"
          logger.error "Invitation e-mail error: #{e.inspect}"
          logger.error "================ DEBUG END ================="
        end
      end
    end
  end

  def resolve_name user
    return user.phone if user.name.blank?
    user.name
  end

  def accept
    # Since the other user is accepting, we search for a contact where user_id
    # is the contact_id from the other user's perspective
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first

    ContactNotifications.status_changed(connection)
    connection.update_attributes!(is_pending: false, is_rejected: false, is_removed: false)
    begin
      current_user.connections.create!(user_id: current_user.id, contact_id: params[:contact_id], is_pending: false)

      render json: {}, status: 200
    rescue
      render json: { error_info: { code: 108, title: '', message: t('errors.connection_exists')  }  }, status: 400
    end
  end

  def decline
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first

    connection.update_attributes!(is_pending: false, is_rejected: true, is_removed: false)

    ContactNotifications.status_changed(connection)

    render json: {}, status: 200
  end

  def remove
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first
    begin
      connection.update_attributes!(is_removed: true, is_rejected: false, is_pending: false) if connection
      Connection.where(user_id: current_user.id, contact_id: params[:contact_id]).first.destroy

      ContactNotifications.status_changed(connection) if connection

      render json: {}, status: 200
    rescue => e
      logger.error "=============== DEBUG START ================"
      logger.error "Debug: #{e.inspect}"
      logger.error "================ DEBUG END ================="
      render json: { error_info: { code: 113, title: '', message: t('errors.url_or_record_not_found') }  }, status: 500
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

