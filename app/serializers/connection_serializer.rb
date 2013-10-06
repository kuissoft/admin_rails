class ConnectionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :contact_id, :is_pending, :is_rejected, :is_removed
end
