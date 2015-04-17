json.array!(@records) do |record|
  json.extract! record, :id, :caller_id, :original_caller_id, :assistant_id, :accepted_at, :declined_at, :started_at, :ended_at, :ended_by, :error
  json.url record_url(record, format: :json)
end
