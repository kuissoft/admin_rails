class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :is_pending, :is_rejected, :is_removed

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
end
