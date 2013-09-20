class ConnectionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :contact_id, :is_pending
end
