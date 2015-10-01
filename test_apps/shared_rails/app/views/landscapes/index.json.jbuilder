json.array!(@landscapes) do |landscape|
  json.extract! landscape, :id, :name
  json.url landscape_url(landscape, format: :json)
end
