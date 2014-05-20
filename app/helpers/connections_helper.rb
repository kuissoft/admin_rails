module ConnectionsHelper
  def viewname user, contact = nil
    if user.name.blank?
      if contact.blank?
        conns = Connection.where(contact_id: user.id)
        conn = conns.last
        conns.each do |c|
          conn = c if c.nickname.present?
        end
      else
        conns = Connection.where(contact_id: user.id, user_id: contact.id)
        conn = conns.last
        conns.each do |c|
          conn = c if c.nickname.present?
        end
      end
      if conn.present?
        unless conn.nickname.blank?
          "(#{conn.nickname})"
        else
          "(User #{user.id})"
        end
      else
        "(User #{user.id})"
      end
    else
      user.name
    end
  end
end
