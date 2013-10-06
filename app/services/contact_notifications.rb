class ContactNotifications
  def self.added(connnection)
    Realtime.new.notify(connnection.contact_id, "contacts:request", {
      sender_id: connnection.user_id
    })
  end

  def self.updated(connnection)
    Realtime.new.notify(connnection.user_id, "contacts:update", {})
  end

  def self.status_changed(connnection)
    Realtime.new.notify(connnection.user_id, "contacts:update", {})
  end

end
