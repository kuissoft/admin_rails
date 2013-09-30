class ContactNotifications
  def self.added(connnection)
    Realtime.new.notify(connnection.contact_id, "contacts:request", { sender_id: connnection.user_id })
  end
end
