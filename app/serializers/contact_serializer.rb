class ContactSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :target_id
end
