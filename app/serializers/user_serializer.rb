class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :email, :authentication_token
end
