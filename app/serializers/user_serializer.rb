class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :authentication_token, :role, :last_token, :token_updated_at, :validation_code 
end
