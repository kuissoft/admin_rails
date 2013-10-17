class Authentication
  def self.validate_token(user, token)
    if user.authentication_token == token && user.token_expired?
      :expired
    else
      :invalid
    end
  end
end
