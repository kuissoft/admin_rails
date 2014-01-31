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

  def self.notifications_updated(connnection)

    Realtime.new.notify(connnection.contact_id, "notifications:update", {notifications_count: get_notifications_count(connnection.contact_id)})
  end

  private
  def self.get_notifications_count user_id
    user = User.where(id: user_id).first
    user.contact_connections.where(is_pending: true).size + user.contact_connections.where(is_rejected: true).size + user.contact_connections.where(is_removed: true).size
  end

end
