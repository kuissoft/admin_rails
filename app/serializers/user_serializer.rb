class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :role, :auth_token

  def auth_token

  end

end
