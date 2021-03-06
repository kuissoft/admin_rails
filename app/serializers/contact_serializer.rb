class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :is_pending, :state, :is_rejected, :is_removed, :nickname, :last_online, :is_online, :connection_type, :photo_url

  def id
    object.contact.id if object.contact
  end

  def name
    object.contact.name if object.contact
  end

  def phone
    object.contact.phone if object.contact
  end

  def last_online
    if object.contact and !object.contact.is_online?
      object.contact.last_online_at
    else
      nil
    end
  end

  def is_online
    object.contact.is_online? if object.contact
  end

  def state
    contact_state = 'offline'
    if object.contact
      if object.contact.is_online? 
        contact_state = 'online'
      else
        contact_state = 'offline'
      end
    end
    contact_state = 'pending' if object.is_pending
    contact_state
  end

  def connection_type
    if object.contact
      con_type = object.contact.strongest_connection
      con_type
    end
  end

  def photo_url
    "#{IMAGES_HOST}#{object.contact.photo.url.gsub(/_.*/,'')}" if object.contact and object.contact.photo.present?
  end
end
