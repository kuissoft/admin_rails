class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :is_pending, :is_rejected, :is_removed

  def id
    object.contact.id
  end

  def name
    object.contact.name
  end

  def email
    object.contact.email
  end

  def phone
    object.contact.phone
  end
end
