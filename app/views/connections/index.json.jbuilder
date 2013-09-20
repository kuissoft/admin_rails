json.array!(@connections) do |connection|
  json.extract! connection, :user_id, :contact_id, :is_pending
  json.url connection_url(connection, format: :json)
end
