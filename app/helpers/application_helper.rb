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

  # Extra class for active menu item
  def current_class?(test_path)
    return 'active' if request.path == test_path
    return 'active' if request.path == root_path && test_path == users_path
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

  def list_users
    "Show users"
  end

  def get_settings_value constant_name, default_value = nil
    setting = Setting.where(name: constant_name.to_s.underscore).first

    if setting
      get_array_or_value setting.value
    else
      default_value
    end
  end
  alias_method :settings_value, :get_settings_value

  protected

  def get_array_or_value value
    values = value.split("|")
    if values.size == 1
      return values.first
    else
      return values
    end
  end


  
end
