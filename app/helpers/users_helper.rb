module UsersHelper

  def connection_info conn, reverse = false
    if conn
      names(conn, reverse) +
      " " +
      content_tag(:span, t('is_pending', scope: 'activerecord.attributes.connection'), class: conn.is_pending ? "green" : "red") +
      " | " +
      content_tag(:span, t('is_rejected', scope: 'activerecord.attributes.connection'), class: conn.is_rejected ? "green" : "red") +
      " | " +
      content_tag(:span, t('is_removed', scope: 'activerecord.attributes.connection'), class: conn.is_removed ? "green" : "red") +
      " | " +
      link_to(image_tag('edit.png'), edit_connection_path(id: conn.id, return_to: conn.user.id, user: (reverse ? conn.contact.id : conn.user.id))) +
      " | " +
      link_to(image_tag('destroy.png'), destroy_connection_users_path(id: @user, conn_id: conn.id), data: { confirm: 'Are you sure?' }, :method => :delete) +
      tag(:br)
    end
  end

  def names conn, reverse
    if reverse
      link_to((conn.contact.name ? conn.contact.name : conn.contact.phone), conn.contact) +
      " <- " +
      link_to((conn.user.name ? conn.user.name : conn.nickname), conn.user)
    else
      link_to((conn.user.name ? conn.user.name : conn.user.phone), conn.user) +
      " -> " +
      link_to((conn.contact.name ? conn.contact.name : conn.nickname), conn.contact)
    end
  end
end
