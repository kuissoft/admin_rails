module UsersHelper

  def connection_info conn, reverse = false
    if conn
      names(conn, reverse) +
      " " +
      content_tag(:span, t('pending'), class: conn.is_pending ? "green" : "red") +
      " | " +
      content_tag(:span, t('rejected'), class: conn.is_rejected ? "green" : "red") +
      " | " +
      content_tag(:span, t('removed'), class: conn.is_removed ? "green" : "red") +
      " | " +
      link_to(image_tag('edit.png'), edit_connection_path(id: conn.id, user: (reverse ? conn.contact.id : conn.user.id))) +
      " | " +
      link_to(image_tag('destroy.png'), destroy_connection_users_path(id: @user, conn_id: conn.id), :confirm => 'Are you sure?', :method => :delete) +
      tag(:br)
    end
  end

  def names conn, reverse
    if reverse
      link_to(conn.contact.name, conn.contact) +
      " <- " +
      link_to(conn.user.name, conn.user)
    else
      link_to(conn.user.name, conn.user) +
      " -> " +
      link_to(conn.contact.name, conn.contact)
    end
  end
end
