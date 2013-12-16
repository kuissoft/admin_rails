module ApplicationHelper
  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    when :warning then "alert alert-warning"
    else
      "alert alert-info"
    end
  end

  # Return relation sign for connection
  def get_relation user, contact_id
    follows = user.follows_me?(contact_id)
    following = user.following?(contact_id)

    if follows and following
      return "<->"
    elsif follows and !following
      return "<-"
    elsif !follows and following
      return "->"
    end
  end
end
