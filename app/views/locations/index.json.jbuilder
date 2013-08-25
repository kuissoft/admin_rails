json.array!(@locations) do |location|
  json.extract! location, :session_id, :lat, :lon, :bearing
  json.url location_url(location, format: :json)
end
