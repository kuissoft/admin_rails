require 'digest/sha1'

class Api::V3::ContactsController < Api::V3::AuthenticatedController
  respond_to :json
  around_action :wrap_transaction
  before_action :set_language, only: [:invite, :accept, :decline, :remove, :cancel_invitation]

  def index
    if current_user.operator?
      service = Service.where(id: current_user.services.first.id).first
      if params[:only_ids]
        render json: {contacts: service.operators(current_user.id).map(&:id)}
      else
        render json: service.operators(current_user.id), each_serializer: ServiceSerializer
      end
    else
      if params[:only_ids]
        render json: {contacts: current_user.connections.where("is_rejected = ? AND is_removed = ? ", false, false).map(&:contact_id)}
      else
        render json: current_user.connections.where("is_rejected = ? AND is_removed = ? ", false, false), each_serializer: ContactSerializer
      end
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
      render json: { error_info: { code: 111, title: '', message: t('errors.user_not_exist', locale: @language) } }, status: 401
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

    # If invited user not exits than create new one
    invited_user = User.create!(phone: phone, password: 'asdfasdf') unless invited_user

    # Find if connection between users exists
    conn = Connection.where(user_id: current_user, contact_id: invited_user).first

    # if connection not exits
    unless conn
      # Build new connection with invited user id
      connection = current_user.connections.build(nickname: params[:contact][:nickname])
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
          sms = send_sms_or_email(connection, current_user, invited_user, @lang)
          if sms.first
            current_user.update sms_count: current_user.sms_count + 1 unless sms.last
            ContactNotifications.status_changed(connection, true)
            render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name , "phone" => invited_user.phone, "state" => 'pending', "nickname" => connection.nickname}}, status: 200
          else
            render json: { error_info: { code: 106, title:'', message: sms[1] } }, status: 401
          end
        else
          ContactNotifications.status_changed(connection, false)
          ContactNotifications.status_changed(other_connection, false)
          render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name , "phone" => invited_user.phone, "state" => 'online', "nickname" => connection.nickname}}, status: 200
        end
      else
        render json: { error_info: { code: 101, title: '', message: connection.errors.full_messages.join(", ") } }, status: 400
      end
    else
      # If connection exists and it's pending send invitation msg agaim
      if conn.is_pending
        sms = send_sms_or_email(conn, current_user, invited_user, @lang)
        if sms.first
          current_user.update sms_count: current_user.sms_count + 1 unless sms.last
          render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name, "state" => 'pending' , "phone" => invited_user.phone, "nickname" => conn.nickname}}, status: 200
          ContactNotifications.status_changed(conn, true)
        else
          render json: { error_info: { code: 106, title:'', message: sms[1] } }, status: 401
        end
      elsif conn.is_rejected or conn.is_removed
        # and if is rejected set connection to pending again
        conn.update is_pending: true, is_rejected: false, is_removed: false
        render json: {invited_user: {"id" => invited_user.id, "name" => invited_user.name, "state" => 'pending' , "phone" => invited_user.phone, "nickname" => conn.nickname}}, status: 200
        ContactNotifications.status_changed(conn, true)
      else
        render json: { error_info: { code: 108, title: '', message: t('errors.connection_exists', locale: @lang) }  }, status: 400
      end
    end
  end


  def send_sms_or_email connection, current_user, invited_user, lang = 'en'
    msg = t('sms.invitation', user: resolve_name(current_user), locale: lang )
    unless Rails.env == 'development' or (invited_user.admin? and get_settings_value(:force_sms) != "1")
      sms = Sms.new(invited_user.phone, msg, lang).deliver
    else
      begin
        Emailer.invitation_email(invited_user, current_user).deliver
        sms = [true, nil, true]
      rescue => e
        Rails.logger.error "Invitation e-mail error: #{e.inspect}"
        sms = [false, ::I18n.t('errors.invitation_cannot_send', locale: lang ), true]
      end
    end
    sms
  end

  def resolve_name user
    return user.phone if user.name.blank?
    user.name
  end

  def accept
    # Since the other user is accepting, we search for a contact where user_id
    # is the contact_id from the other user's perspective
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first

    if connection
      ContactNotifications.status_changed(connection, false)
      connection.update_attributes!(is_pending: false, is_rejected: false, is_removed: false)
      begin
        current_user.connections.create!(user_id: current_user.id, contact_id: params[:contact_id], is_pending: false)

        render json: {}, status: 200
      rescue
        render json: { error_info: { code: 108, title: '', message: t('errors.connection_exists', locale: @lang)  }  }, status: 400
      end
    else
      render json: { error_info: { code: 118, title: '', message: t('errors.connection_not_exists', locale: @lang)  }  }, status: 401
    end
  end

  def decline
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first

    if connection
      connection.update_attributes!(is_pending: false, is_rejected: true, is_removed: false)

      ContactNotifications.status_changed(connection, false)

      render json: {}, status: 200
    else
      render json: { error_info: { code: 118, title: '', message: t('errors.connection_not_exists', locale: @lang)}  }, status: 401
    end
  end

  def remove
    connection = Connection.where(user_id: params[:contact_id], contact_id: current_user.id).first
    begin
      connection.update_attributes!(is_removed: true, is_rejected: false, is_pending: false) if connection
      Connection.where(user_id: current_user.id, contact_id: params[:contact_id]).first.destroy

      ContactNotifications.status_changed(connection, false) if connection

      render json: {}, status: 200
    rescue => e
      logger.error "Debug: #{e.inspect}"
      render json: { error_info: { code: 113, title: '', message: t('errors.url_or_record_not_found', locale: @lang) }  }, status: 500
    end
  end

  def cancel_invitation
    connection = Connection.where(user_id: params[:user_id], contact_id: params[:contact_id]).first

    if connection and connection.is_pending
      if connection.destroy
        render json: {}, status: 200
      else
        render json: { errors_info: {code: 101, title: '', messages: "#{connection.errors.full_messages.join(", ")}"} }, status: 400
      end
    else
      render json: { error_info: { code: 117, title: '', message: t('errors.connection_pending_not_exists', locale: @lang) }  }, status: 401
    end
  end

  def dismiss
    connection = Connection.where(user_id: current_user.id, contact_id: params[:contact_id]).first
    connection.destroy if connection

    render json: {}, status: 200
  end

  private

  def set_language
    @lang = @device.language
    @lang = 'en' unless @lang == 'cs' or @lang == 'sk'
  end

  def wrap_transaction
    ActiveRecord::Base.transaction do
      yield
    end
  end

  def contact_params
    params.require(:contact).permit(:contact_id, :nickname)
  end
end
