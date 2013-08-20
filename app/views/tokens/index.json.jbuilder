json.array!(@tokens) do |token|
  json.extract! token, :token_id, :user_id, :session_id
  json.url token_url(token, format: :json)
end
