json.array!(@users) do |user|
  json.extract! user, :name, :phone, :email, :type
  json.url user_url(user, format: :json)
end
