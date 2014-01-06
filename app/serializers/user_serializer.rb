class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone, :auth_token, :role, :last_token, :token_updated_at, :validation_code 
end
