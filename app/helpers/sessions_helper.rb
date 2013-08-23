module SessionsHelper
  
  # Returns line-through font style if the sender is currently not in the session.
  def sender_font_style(session)
    if session.sender
      # sender was previously connected, but lost token or has a token for a different session
      if !session.sender.token || !(session.tokens.include? session.sender.token)
        return "style='text-decoration: line-through;'".html_safe
      end
    end
  end
  
  # Returns line-through font style if the recipient is currently not in the session.
  def recipient_font_style(session)
    if session.recipient
      # sender was previously connected, but lost token or has a token for a different session
      if !session.recipient.token || !(session.tokens.include? session.recipient.token)
        return "style='text-decoration: line-through;'".html_safe
      end
    end
  end
end
