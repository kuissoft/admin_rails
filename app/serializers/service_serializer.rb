class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :state, :last_online, :is_online, :connection_type, :photo_url

  def last_online
    if !object.is_online?
      object.last_online_at
    else
      nil
    end
  end

  def is_online
    object.is_online?
  end

  def state
    contact_state = 'offline'

    if object.is_online? 
      contact_state = 'online'
    else
      contact_state = 'offline'
    end

    contact_state
  end

  def connection_type
    object.strongest_connection
  end

  def photo_url
    "#{IMAGES_HOST}#{object.photo.url.gsub(/_.*/,'')}" if object.photo.present?
  end
end
