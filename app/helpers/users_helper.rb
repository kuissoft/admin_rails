module UsersHelper
  # Return relation sign for connection
  def get_relation contact_id
    follows = @user.follows_me?(contact_id)
    following = @user.following?(contact_id)

    if follows and following
      return "<->"
    elsif follows and !following
      return "<-"
    elsif !follows and following
      return "->"
    end
  end

  def connection_info conn
    if conn
      names(conn) +
      " " + 
      content_tag(:span, t('pending'), class: conn.is_pending ? "green" : "red") +
      " | " +
      content_tag(:span, t('rejected'), class: conn.is_rejected ? "green" : "red") +
      " | " +
      content_tag(:span, t('removed'), class: conn.is_removed ? "green" : "red") +
      tag(:br)
    end
  end

  def names conn
    link_to(conn.user.name, conn.user) +
    " ->" +
    link_to(conn.contact.name, conn.contact)
  end
end
