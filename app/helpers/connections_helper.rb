module ConnectionsHelper
  def viewname user, contact = nil
    if user.name.empty?
      if contact.nil?
        conn = Connection.where(contact_id: user.id).first
      else
        conn = Connection.where(contact_id: user.id, user_id: contact.id).first
      end
      unless conn.nickname.blank?
        "(#{conn.nickname})"
      else
        "(User #{user.id})"
      end
    else
      user.name
    end
  end

end