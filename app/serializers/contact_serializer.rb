class ContactSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :target_id, :is_pending, :is_rejected, :is_removed
end
