class RecordSerializer < ActiveModel::Serializer
  attributes :id, :caller_id, :original_caller_id, :assistant_id, :accepted_at, :declined_at, :started_at, :ended_at, :ended_by, :error
end
