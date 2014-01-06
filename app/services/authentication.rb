class Authentication
  def self.validate_token(user, token)
    if user.auth_token == token && user.expired_token?
      :expired
    elsif user.auth_token == token && !user.expired_token?
      :valid
    else
      :invalid
    end
  end
end
