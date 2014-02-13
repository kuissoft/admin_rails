class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :is_pending, :is_rejected, :is_removed, :nickname, :last_online, :is_online, :connection_type

  def id
    object.contact.id if object.contact
  end

  def name
    object.contact.name if object.contact
  end

  def email
    object.contact.email if object.contact
  end

  def phone
    object.contact.phone if object.contact
  end

  def last_online
    object.contact.last_sign_in_at if object.contact
  end

  def is_online
    object.contact.is_online if object.contact
  end

  def connection_type
    object.contact.connection_type if object.contact
  end
end
